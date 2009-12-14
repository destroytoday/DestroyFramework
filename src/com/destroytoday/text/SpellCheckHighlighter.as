package com.destroytoday.text {
	import com.adobe.linguistics.spelling.SpellChecker;
	import com.adobe.linguistics.spelling.SpellingDictionary;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	
	[Event(name="update", type="flash.events.Event")]

	/**
	 * The SpellCheckHighlighter underlines misspelled words in a TextField instance.
	 * It also adds suggestions to the context menu of misspelled words.
	 * Note: This class requires Adobe Squiggly
	 * @see http://labs.adobe.com/technologies/squiggly/
	 * @author Jonnie Hallman
	 */	
	public class SpellCheckHighlighter extends Shape {
		/* Characters that cannot exist within words
		* @private
		*/		
		private static const ILLEGAL_CHARACTERS:String = "!@#$%\\^&*()+{}\\[\\]:\"\\/\\\\|_~`\\.,\\-<>\\s";
		
		/**
		 * Regular expression used to pad words with &lt; and &gt; so indexOf wouldn't identify a word within a word.
		 * @private 
		 */		
		private static const WORDS_REPLACE_REGEX:RegExp = new RegExp("\\b([^" + ILLEGAL_CHARACTERS + "]+)\\b", "g");
		
		/**
		 * Regular expression to match padded words.
		 * @private 
		 */		
		private static const WORDS_MATCH_REGEX:RegExp = new RegExp("<[^" + ILLEGAL_CHARACTERS + "]+>", "g");
		
		/**
		 * @private 
		 */		
		protected var _textfield:TextField;
		
		/**
		 * @private 
		 */		
		protected var _spellChecker:SpellChecker = new SpellChecker();
		
		/**
		 * @private 
		 */		
		protected var spellingDictionary:SpellingDictionary = new SpellingDictionary();
		
		/**
		 * Delays the update while the TextField is changing.
		 * @private 
		 */		
		protected var timer:Timer = new Timer(500, 1);
		
		/**
		 * Vector of the misspelled words.
		 * @private 
		 */		
		protected var _misspelledWords:Vector.<String> = new Vector.<String>();
		
		/**
		 * Vector of the startIndex and endIndex of each word.
		 * @private 
		 */		
		protected var misspelledRanges:Vector.<int> = new Vector.<int>();
		
		/**
		 * @private
		 */		
		protected var _enabled:Boolean = true;
		
		/**
		 * @private 
		 */		
		protected var _underlineOffset:Number = 0.0;
		
		/**
		 * @private 
		 */		
		protected var _underlineStyle:String;
		
		/**
		 * @private 
		 */		
		protected var dottedBitmapData:BitmapData;
		
		/**
		 * @private 
		 */		
		protected var waveBitmapData:BitmapData;
		
		/**
		 * @private 
		 */		
		protected var _underlineColor:uint = 0xFF0000;
		
		/**
		 * @private 
		 */		
		protected var _variableFontSize:Boolean;
		
		/**
		 * The vertical offset countering the vertical scroll.
		 * @private 
		 */		
		protected var offsetY:Number = 0.0;
		
		/**
		 * The word that is right-clicked for suggestions.
		 * Since Flash Player doesn't allow the ContextMenuItem.data property to store the word,
		 * the word must be stored here for when the user selects a suggestion.
		 * @private 
		 */		
		protected var rightClickedWord:String;
		
		/**
		 * Instantiates the SpellCheckHighlighter.
		 * @param textfield the TextField to spell check and highlight
		 */		
		public function SpellCheckHighlighter(textfield:TextField) {
			this.textfield = textfield;
			
			// set here so the bitmapData is instantiated and drawn
			underlineStyle = SpellCheckHighlightStyle.WAVE;
			
			spellingDictionary.addEventListener(Event.COMPLETE, dictionaryLoadedHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
		}
		
		/**
		 * The TextField to spell check and highlight.
		 * @return 
		 */		
		public function get textfield():TextField {
			return _textfield;
		}
		
		/**
		 * @private
		 * @param textfield
		 */		
		public function set textfield(textfield:TextField):void {
			if (_textfield == textfield) return;
			
			if (_textfield) {
				// release ContextMenu items
				(_textfield.contextMenu as ContextMenu).customItems.length = 0;
				
				_textfield.removeEventListener(Event.ADDED_TO_STAGE, textfieldAddedToStageHandler);
				_textfield.removeEventListener(Event.REMOVED_FROM_STAGE, textfieldRemovedFromStageHandler);
				
				removeTextFieldListeners();
			}
			
			_textfield = textfield;
			
			// if the TextField is null, reset the highlighter
			if (!_textfield) {
				reset();
				
				return;
			}
			
			if (!_textfield.contextMenu) _textfield.contextMenu = new ContextMenu();

			_textfield.addEventListener(Event.ADDED_TO_STAGE, textfieldAddedToStageHandler, false, 0, true);
			_textfield.addEventListener(Event.REMOVED_FROM_STAGE, textfieldRemovedFromStageHandler, false, 0, true);
			
			addTextFieldListeners();
			
			// position the highlighter with the TextField.
			// be sure to set the TextField's position prior to attaching the highlighter.
			// if the TextField moves, be sure to move the highlighter accordingly.
			reposition();
			
			// if the TextField is already on the stage and the highlighter isn't, add it
			if (_textfield.parent && !parent) {
				_textfield.parent.addChild(this);
			}
			
			clearAndDelay();
		}
		
		/**
		 * Specifies whether the spell checker and highlighter are enabled or not.
		 * @default true 
		 * @return 
		 */		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set enabled(value:Boolean):void {
			if (_enabled == value) return;
			
			_enabled = value;
			
			if (_enabled) {
				addTextFieldListeners();
				clearAndDelay();
			} else {
				reset();
				removeTextFieldListeners();
			}
		}
		
		/**
		 * A cloned vector of the misspelled words in the TextField.
		 * @return 
		 */		
		public function get misspelledWords():Vector.<String> {
			return _misspelledWords.concat();
		}
		
		/**
		 * The y-offset of the underline from the misspelled words. 
		 * @default 0
		 * @return 
		 */		
		public function get underlineOffset():Number {
			return _underlineOffset;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set underlineOffset(value:Number):void {
			if (_underlineOffset == value) return;
			
			_underlineOffset = value;
			
			updateUnderlineStyle();
			redrawUnderlines();
		}
		
		/**
		 * The style of the misspelled words' underline. 
		 * @default SpellCheckHighlightStyle.WAVE
		 * @return 
		 */		
		public function get underlineStyle():String {
			return _underlineStyle;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set underlineStyle(value:String):void {
			if (_underlineStyle == value) return;
			
			_underlineStyle = value;
			
			updateUnderlineStyle(true);
			redrawUnderlines();
		}
		
		/**
		 * The delay in milliseconds between the TextField changing and the SpellChecker updating.
		 * @default 500
		 * @return 
		 */		
		public function get delay():Number {
			return timer.delay;
		}
		
		/**
		 * @private
		 * @param value
		 */		
		public function set delay(value:Number):void {
			timer.delay = value;
			
			clearAndDelay();
		}
		
		/**
		 * The color of the misspelled words' underline. 
		 * @default 0xFF0000
		 * @return 
		 */		
		public function get underlineColor():uint {
			return _underlineColor;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set underlineColor(value:uint):void {
			if (underlineColor == value) return;
			
			_underlineColor = value;
			
			updateUnderlineStyle(true);
			redrawUnderlines();
		}
		
		/**
		 * Specifies whether there are variable font sizes in the TextField.
		 * @default false
		 * @return 
		 */		
		public function get variableFontSize():Boolean {
			return _variableFontSize;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set variableFontSize(value:Boolean):void {
			_variableFontSize = value;
			
			clearAndDelay();
		}
		
		/**
		 * Loads a dictionary file.
		 * @param url the URL of the dictionary file
		 */		
		public function loadDictionary(url:String):void {
			spellingDictionary.load(new URLRequest(url));
		}
		
		/**
		 * @private
		 */		
		protected function addTextFieldListeners():void {
			_textfield.addEventListener(Event.CHANGE, textfieldChangeHandler, false, 0, true);
			_textfield.addEventListener(Event.SCROLL, textfieldChangeHandler, false, 0, true);
			_textfield.contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, textfieldContextMenuHandler, false, 0, true);
		}
		
		/**
		 * @private
		 */		
		protected function removeTextFieldListeners():void {
			_textfield.removeEventListener(Event.CHANGE, textfieldChangeHandler);
			_textfield.removeEventListener(Event.SCROLL, textfieldChangeHandler);
			_textfield.removeEventListener(MouseEvent.CONTEXT_MENU, textfieldContextMenuHandler);
		}
		
		/**
		 * Erases the highlighter, empties misspelled word vectors, and stop the delay.
		 */		
		protected function reset():void {
			graphics.clear();
			
			misspelledRanges.length = 0;
			_misspelledWords.length = 0;
			
			timer.reset();
		}
		
		/**
		 * Draws an underline between the indices.
		 * @private
		 * @param wordStartIndex
		 * @param wordEndIndex
		 */		
		protected function underlineWord(wordStartIndex:int, wordEndIndex:int):void {
			var charBounds:Rectangle;
			var wordLeft:Number, wordRight:Number, wordBottom:Number;
			
			// get the line index where the word begins
			var startLine:int = _textfield.getLineIndexOfChar(wordStartIndex);
			
			// get the line where the word ends
			// 99.9% of the time, endLine will equal startLine, 
			// but if for some reason there's a word that carries over more than one line,
			// it is all handled.
			var endLine:int = _textfield.getLineIndexOfChar(wordEndIndex);
			var m:int = endLine;

			// loop through the lines containing the word
			for (var i:uint = startLine; i <= m; ++i) {
				
				// if this is the line where the word starts, get the position of the first letter of the word
				// if not, get the position of the first letter in the line
				if (i == startLine) {
					charBounds = _textfield.getCharBoundaries(wordStartIndex);
				} else {
					charBounds = _textfield.getCharBoundaries(_textfield.getLineOffset(i));
				}

				wordLeft = charBounds.left;
				wordBottom = charBounds.bottom - offsetY + _underlineOffset;
				
				// if this is the line where the word ends, get the position of the last letter of the word
				// if not, get the position of the last letter in the line
				if (i == endLine) {
					charBounds = _textfield.getCharBoundaries(wordEndIndex - 1);
				} else {
					charBounds = _textfield.getCharBoundaries(_textfield.getLineOffset(i) + _textfield.getLineLength(i) - 1);
				}
				
				wordRight = charBounds.right;
				
				// draw line
				switch(_underlineStyle) {
					case SpellCheckHighlightStyle.SOLID:
						graphics.moveTo(wordLeft, wordBottom);
						graphics.lineTo(wordRight, wordBottom);
						break;
					case SpellCheckHighlightStyle.DOTTED:
						graphics.beginBitmapFill(dottedBitmapData);
						graphics.drawRect(wordLeft, wordBottom, wordRight - wordLeft, dottedBitmapData.height);
						graphics.endFill();
						break;
					case SpellCheckHighlightStyle.WAVE:
						graphics.beginBitmapFill(waveBitmapData);
						graphics.drawRect(wordLeft, wordBottom, wordRight - wordLeft, waveBitmapData.height);
						graphics.endFill();
						break;
				}
			}
		}
		
		/**
		 * @private 
		 */		
		protected function updateUnderlineStyle(updateBitmap:Boolean = false):void {
			var color:uint;
			
			graphics.clear();
			
			if (_underlineStyle != SpellCheckHighlightStyle.SOLID && !updateBitmap) return;
			
			switch (_underlineStyle) {
				case SpellCheckHighlightStyle.SOLID:
					graphics.lineStyle(2, _underlineColor);
					break;
				case SpellCheckHighlightStyle.DOTTED:
					if (!dottedBitmapData) dottedBitmapData = new BitmapData(4, 2, true, 0x00000000);
					
					color = 0xFF000000 | _underlineColor;
					
					dottedBitmapData.setPixel32(0, 0, color);
					dottedBitmapData.setPixel32(1, 0, color);
					dottedBitmapData.setPixel32(0, 1, color);
					dottedBitmapData.setPixel32(1, 1, color);
					break;
				case SpellCheckHighlightStyle.WAVE:
					if (!waveBitmapData) waveBitmapData = new BitmapData(2, 2, true, 0x00000000);
					
					color = 0xFF000000 | _underlineColor;
					
					waveBitmapData.setPixel32(0, 0, color);
					waveBitmapData.setPixel32(1, 1, color);
					
					break;
			}
		}
		
		/**
		 * @private
		 */		
		protected function redrawUnderlines():void {
			var wordStartIndex:int, wordEndIndex:int;
			
			var m:uint = misspelledRanges.length;
			
			// loop through the words
			for (var i:uint = 0; i < m; i += 2) {
				// get the indices from the range list
				wordStartIndex = misspelledRanges[i];
				wordEndIndex = misspelledRanges[i + 1];
				
				// underline the word
				underlineWord(wordStartIndex, wordEndIndex);
			}
		}
		
		/**
		 * Erases the underlines and restarts the delay if the highlighter is enabled.
		 * @private
		 */		
		protected function clearAndDelay():void {
			updateUnderlineStyle();
			
			timer.reset();
			if (_enabled) timer.start();
		}
		
		/**
		 * @private
		 */		
		protected function hideContextMenuItems():void {
			var item:ContextMenuItem;
			
			var menu:ContextMenu = _textfield.contextMenu as ContextMenu;
			var m:uint = menu.customItems.length;
			
			for (var i:uint = 0; i < m; ++i) {
				item = menu.customItems[i];
				
				item.visible = false;
			}
		}
		
		/**
		 * Moves the highlighter to the TextField's position.
		 */		
		public function reposition():void {
			if (_textfield) {
				x = _textfield.x;
				y = _textfield.y;
			}
		}
		
		/**
		 * Analyzes the TextField and updates the misspelled words list.
		 */		
		public function update():void {
			// empty the misspelled words and ranges
			_misspelledWords.length = 0;
			misspelledRanges.length = 0;
			
			if (!_textfield || !_textfield.text || !spellingDictionary.loaded) {
				offsetY = 0.0;
				
				return;
			}
			
			// instantiate the temporary variables here, in case the TextField is null or the text is empty
			var i:uint, m:uint;
			var match:String, word:String;
			var matchEndIndex:int, wordStartIndex:int, wordEndIndex:int, indexOffset:int;
			var lineMetrics:TextLineMetrics;
			
			// TextField's vertical scroll where the top is 0, not the default 1
			// storing the scroll is faster than getting it from the TextField and subtracting each time
			var scrollV:int = _textfield.scrollV - 1;
			var bottomScrollV:int = _textfield.bottomScrollV - 1;
			
			// get the vertical offset of the first visible line
			// if variableFontSize is true, total the line heights prior to the first visible line (slow)
			// if not, assume all line heights are the same and multiply (fast)
			if (_variableFontSize) {
				m = scrollV;
				offsetY = 0.0;
				
				for (i = 0; i < m; ++i) {
					lineMetrics = _textfield.getLineMetrics(i);
					offsetY += lineMetrics.height;
				}
			} else {
				lineMetrics = _textfield.getLineMetrics(0);
				offsetY = lineMetrics.height * (scrollV);
			}
			
			// get the index of first character in the visible text
			var textStartIndex:int = _textfield.getLineOffset(scrollV)
				
			// get the index of the last character in the visible text
			var textEndIndex:int = _textfield.getLineOffset(bottomScrollV) + _textfield.getLineLength(bottomScrollV) - 1;
			
			// trim the text to the visible text
			var text:String = _textfield.text;
			text = text.substring(textStartIndex, textEndIndex);
			
			// pad the words so words within words aren't matched with indexOf, since it doesn't have boundary markers like RegEx
			text = text.replace(/[<>]/g, ".");
			text = text.replace(WORDS_REPLACE_REGEX, "<$1>");
				
			// get an array of all the words in the visible text
			var matches:Array = text.match(WORDS_MATCH_REGEX);
			var matchStartIndex:int = -1;
			m = matches.length;

			// loop through the words
			for (i = 0; i < m; ++i) {
				match = matches[i];
				
				// unpad the word
				word = match.substr(1, match.length - 2);

				// get the index of the padded word
				matchStartIndex = text.indexOf(match, matchStartIndex + 1);
				matchEndIndex = matchStartIndex + match.length;
				
				// get the index of the unpadded word
				wordStartIndex = textStartIndex + matchStartIndex - (2 * i);
				wordEndIndex = wordStartIndex + word.length;

				// check if the word is spelled correctly
				if (!_spellChecker.checkWord(word)) {
					// add it to the misspelled word list if it's not there already
					if (_misspelledWords.indexOf(word) != -1) _misspelledWords[_misspelledWords.length] = word;
					
					// add the indices to the range list
					misspelledRanges[misspelledRanges.length] = wordStartIndex;
					misspelledRanges[misspelledRanges.length] = wordEndIndex;

					// underline the word
					underlineWord(wordStartIndex, wordEndIndex);
				}
			}
			
			// dispatch a change event only if something is listening
			if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Adds the SpellingDictionary to the SpellChecker once it is loaded.
		 * @private
		 * @param event
		 */		
		protected function dictionaryLoadedHandler(event:Event):void {
			_spellChecker.addDictionary(spellingDictionary);
			
			clearAndDelay();
		}
		
		/**
		 * Adds the highlighter to the stage when the TextField is added to the stage
		 * @private
		 * @param event
		 */		
		protected function textfieldAddedToStageHandler(event:Event):void {
			if (!parent && !_textfield.parent.contains(this)) {
				_textfield.parent.addChild(this);
			}
		}
		
		/**
		 * Removes the highlighter from the stage when the Textfield is removed from the stage
		 * @private
		 * @param event
		 */		
		protected function textfieldRemovedFromStageHandler(event:Event):void {
			if (parent && parent.contains(this)) {
				parent.removeChild(this);
			}
		}
		
		/**
		 * Starts the delay when the TextField's text or scroll changes.
		 * @private
		 * @param event
		 */		
		protected function textfieldChangeHandler(event:Event):void {
			clearAndDelay();
		}
		
		/**
		 * Calls for an update after the delay.
		 * @private
		 * @param event
		 */		
		protected function timerHandler(event:TimerEvent):void {
			update();
		}
		
		/**
		 * Updates the ContextMenu with the suggestions of the right-clicked word.
		 * TODO: Recycle context menu items. AIR currently throws an error when trying to recycle items with the ContextMenu class. A fix is in the works.
		 * @param event
		 */		
		protected function textfieldContextMenuHandler(event:Event):void {
			var wordStartIndex:int, wordEndIndex:int;
			var item:ContextMenuItem;
			var word:String, suggestion:String;
			var suggestions:Array;
			
			// for some odd reason, the TextField's contextMenu returns it as a NativeMenu (its super),
			// so we must type it as a ContextMenu
			var menu:ContextMenu = _textfield.contextMenu as ContextMenu;
			
			// get the index of the right-clicked character
			var charIndex:int = _textfield.getCharIndexAtPoint(_textfield.mouseX, _textfield.mouseY);
			
			// empty the right-clicked word, so it can be used to indicate whether a word was right-clicked this time
			rightClickedWord = null;

			// if there isn't a character at the mouse coords, hide items and abort
			if (charIndex == -1) {
				hideContextMenuItems();
				
				return;
			}
			
			var m:uint = misspelledRanges.length;
			
			// loop through ranges, skipping every two indices
			for (var i:uint = 0; i < m; i += 2) {
				// startIndex has an even index
				wordStartIndex = misspelledRanges[i];
				
				// endIndex has an odd index
				wordEndIndex = misspelledRanges[i + 1];
				
				// if the right-clicked character is within this word's range, get its suggestions
				if (charIndex >= wordStartIndex && charIndex <= wordEndIndex) {
					rightClickedWord = _textfield.text.substring(wordStartIndex, wordEndIndex);

					suggestions = _spellChecker.getSuggestions(rightClickedWord);
					
					// the max number of suggestions
					var n:uint = 10;
					
					for (var j:uint = 0; j < n; ++j) {
						// preallocate the ContextMenu, so we're not instantiating new items each right-click
						if (menu.customItems.length < n) {
							item = menu.customItems[menu.customItems.length] = new ContextMenuItem("");
							
							item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, suggestionSelectHandler, false, 0, true);
						} else {
							item = menu.customItems[j];
						}
						
						// if there are no suggestions, say so
						// if there are, add them to the ContextMenu
						// otherwise, hide unused items
						if (suggestions.length == 0 && j == 0) {
							item.caption = "No suggestions";
							item.enabled = false;
							item.visible = true;
						} else if (j < suggestions.length) {
							item.caption = suggestions[j];
							item.enabled = true;
							item.visible = true;
						} else {
							item.visible = false;
						}
					}
					
					break;
				}
			}
			
			// if a misspelled word isn't right-clicked, hide the ContextMenu items
			if (!rightClickedWord) hideContextMenuItems();
		}
		
		/**
		 * Replaces the right-clicked word with the selected suggestion.
		 * @param event
		 */		
		protected function suggestionSelectHandler(event:ContextMenuEvent):void {
			var item:ContextMenuItem = event.target as ContextMenuItem;
			
			// construct regular express to match misspelled word
			var pattern:String = "\\b" + rightClickedWord + "\\b";
			
			// empty the stored word
			rightClickedWord = null;

			// replace misspelled word with suggestion
			_textfield.text = _textfield.text.replace(new RegExp(pattern, "g"), item.caption);
			
			clearAndDelay();
		}
	}
}