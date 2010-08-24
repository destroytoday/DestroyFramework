package com.destroytoday.layouts {
	import com.destroytoday.display.IGroup;
	import com.destroytoday.display.InvalidationSprite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class BasicLayout {
		protected var _paddingLeft:Number = 0.0;
		
		protected var _paddingTop:Number = 0.0;
		
		protected var _paddingRight:Number = 0.0;
		
		protected var _paddingBottom:Number = 0.0;
		
		public function BasicLayout() 
		{
		}
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}

		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}
		
		public function setPadding(left:Number, top:Number, right:Number, bottom:Number):void
		{
			_paddingLeft = left;
			_paddingTop = top;
			_paddingRight = right;
			_paddingBottom = bottom;
		}

		public function updateDisplayList(group:IGroup):void 
		{
			var element:IConstrainedLayoutElement;
			
			//var m:uint = group.numElements;
			// The value m was getting stale and causing the getElementAt to fail
			// by adding group.numElements, we are safe
			
			for (var i:uint = 0; i < group.numElements; ++i) 
			{
				if ((element = group.getElementAt(i) as IConstrainedLayoutElement)) {
					// width
					if ((element.left < 0 || element.left >= 0) && (element.right < 0 || element.right >= 0)) {
						element.width = group.width - (element.left + element.right + _paddingLeft + _paddingRight);
					}
					
					// height
					if ((element.top < 0 || element.top >= 0) && (element.bottom < 0 || element.bottom >= 0)) {
						element.height = group.height - (element.top + element.bottom + _paddingTop + _paddingBottom);
					}
					
					// x
					// left and right take priority over center
					if (element.left < 0 || element.left >= 0) {
						element.x = _paddingLeft + element.left;
					} else if (element.right < 0 || element.right >= 0) {
						element.x = group.width - (_paddingRight + element.width + element.right);
					} else if (element.center < 0 || element.center >= 0) {
						element.x = ((group.width  - (_paddingLeft + _paddingRight)) - element.width) * 0.5 + element.center;
					}

					// y
					// top and bottom take priority over middle
					if (element.top < 0 || element.top >= 0) {
						element.y = _paddingTop + element.top;
					} else if (element.bottom < 0 || element.bottom >= 0) {
						element.y = group.height - (_paddingBottom + element.height + element.bottom);
					} else if (element.middle < 0 || element.middle >= 0) {
						element.y = ((group.height  - (_paddingTop + _paddingBottom)) - element.height) * 0.5 + element.middle;
					}
					
					if (element is InvalidationSprite) (element as InvalidationSprite).validateNow();
				}
			}
		}
	}
}