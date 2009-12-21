package com.destroytoday.text {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	/**
	 * The TextFieldPlus class fixes the autoSize bugs in the TextField class.
	 * @author Jonnie Hallman
	 * @see http://destroytoday.com/blog/2008/08/workaround-001-actionscripts-autosize-bug/
	 */	
	public class TextFieldPlus extends TextField {
		/**
		 * @private 
		 */		
		protected var _autoSize:String = TextFieldAutoSize.NONE;
		
		/**
		 * @private 
		 */		
		protected var _heightOffset:Number = 0;
		
		/**
		 * @private 
		 */		
		protected var _text:String = "";
		
		/**
		 * @private 
		 */		
		protected var _html:Boolean;
		
		/**
		 * @private
		 */		
		protected var needsUpdate:Boolean;
		
		/**
		 * @private 
		 */		
		protected var _inTransaction:Boolean;
		
		/**
		 * Creates a new TextFieldPlus instance.
		 */		
		public function TextFieldPlus() {
		}
		
		/**
		 * Indicates whether the TextField is batch appending using begin/commit.
		 * @return 
		 */		
		public function inTransaction():Boolean {
			return _inTransaction;
		}
		
		/**
		 * The number of pixels to offset the TextField's height by.
		 * This property is used to fix the bug where multiline TextFields scroll when autoSize is set.
		 * @return
		 */		
		public function get heightOffset():Number {
			return _heightOffset;
		}
		
		/**
		 * @private
		 */		
		public function set heightOffset(value:Number):void {
			_heightOffset = value; updateSize();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function get autoSize():String {
			return _autoSize; 
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set autoSize(value:String):void {
			_autoSize = value;
			
			if (multiline) {
				updateSize();
			} else {
				super.autoSize = _autoSize;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set multiline(value:Boolean):void {
			super.multiline = value;
			
			if (multiline && _autoSize != TextFieldAutoSize.NONE) {
				updateSize();
			} else {
				super.autoSize = _autoSize;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function get text():String {
			if (_html || needsUpdate || type == TextFieldType.INPUT) {
				needsUpdate = false;
				
				_text = super.text;
			}
			
			return _text;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set text(value:String):void {
			needsUpdate = false;
			
			_html = false;
			_text = value;

			if (!_inTransaction) super.text = value;
			
			if (multiline && _autoSize != TextFieldAutoSize.NONE) updateSize();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set htmlText(value:String):void {
			_html = true;
			
			super.htmlText = value;
			
			if (multiline && _autoSize != TextFieldAutoSize.NONE) updateSize();
		}
		
		/**
		 * Indicates whether the TextField's text was set through <code>htmlText</code> (true) or <code>text</code> (false).
		 * @return 
		 */		
		public function get html():Boolean {
			return _html;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function appendText(newText:String):void {
			if (!_inTransaction) super.appendText(newText);
			if (!_html && !needsUpdate) _text += newText;
			if (multiline && _autoSize != TextFieldAutoSize.NONE) updateSize();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function replaceText(beginIndex:int, endIndex:int, newText:String):void {
			super.replaceText(beginIndex, endIndex, newText);
			
			if (beginIndex == length && !_html && !needsUpdate) {
				_text += newText;
			} else {
				needsUpdate = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function replaceSelectedText(value:String):void {
			super.replaceSelectedText(value);
			
			needsUpdate = true;
		}
		
		public function beginText():void {
			_inTransaction = true;
			
			if (needsUpdate) _text = text;
		}
		
		public function commitText():void {
			_inTransaction = false;
			
			text = _text;
		}
		
		/**
		 * @private
		 */		
		protected function updateSize():void {
			// temporarily set autoSize to actual value
			super.autoSize = _autoSize;
			
			// record height when auto-sized
			var height:Number = this.height;
			
			// remove autoSize 
			super.autoSize = TextFieldAutoSize.NONE;
			
			// resize using recorded height and offset
			this.height = height + _heightOffset;
		}
	}
}