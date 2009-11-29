package com.destroytoday.text {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/*
	The MIT License
	
	Copyright (c) 2009 Jonnie Hallman
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	*/
	
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
			
			updateSize();
		}
		
		/**
		 * Creates a new TextFieldPlus instance.
		 */		
		public function TextFieldPlus() {
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set text(value:String):void {
			super.text = value;
			
			updateSize();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function set htmlText(value:String):void {
			super.htmlText = value;
			
			updateSize();
		}
		
		/**
		 * @private
		 */		
		protected function updateSize():void {
			if (!multiline || _autoSize == TextFieldAutoSize.NONE) return;
			
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