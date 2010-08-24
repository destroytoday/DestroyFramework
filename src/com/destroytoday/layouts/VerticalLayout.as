package com.destroytoday.layouts
{
	import com.destroytoday.display.IGroup;
	import com.destroytoday.display.InvalidationSprite;

	public class VerticalLayout extends BasicLayout
	{
		private var _horizontalAlign:String;
		
		protected var _gap:Number = 0.0;
		
		public function VerticalLayout()
		{
		}
		
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		public function set horizontalAlign(value:String):void
		{
			_horizontalAlign = value;
		}

		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap = value;
		}

		override public function updateDisplayList(group:IGroup):void
		{
			var element:IBasicLayoutElement;
			var y:Number, paddingLeft:Number, paddingRight:Number;
			var horizontalAlign:String;
			
			var m:uint = group.numElements;

			y = _paddingTop;
			
			for (var i:uint = 0; i < m; ++i) {
				paddingLeft = _paddingLeft;
				paddingRight = _paddingRight;
				
				element = group.getElementAt(i);
				
				if (!element || (element is INonLayoutElement && !(element as INonLayoutElement).includeInLayout)) continue;
				
				if (element is IMarginedLayoutElement) {
					paddingLeft += (element as IMarginedLayoutElement).marginLeft;
					paddingRight += (element as IMarginedLayoutElement).marginRight;
					
					y += (element as IMarginedLayoutElement).marginTop;
				}
				
				if (element is InvalidationSprite) (element as InvalidationSprite).validateNow();

				element.y = y;
				
				horizontalAlign = (element is IAlignedLayoutElement && (element as IAlignedLayoutElement).align) ? (element as IAlignedLayoutElement).align : _horizontalAlign;
				
				switch (horizontalAlign) {
					case HorizontalAlignType.LEFT:
						element.x = paddingLeft;
						break;
					case HorizontalAlignType.CENTER:
						element.x = paddingLeft + (group.width - (paddingLeft + paddingRight + element.width)) * 0.5;
						break;
					case HorizontalAlignType.RIGHT:
						element.x = group.width - (paddingRight + element.width);
						break;
					case HorizontalAlignType.JUSTIFY:
						element.x = paddingLeft;
						element.width = group.width - (paddingLeft + paddingRight);
						
						if (element is InvalidationSprite) (element as InvalidationSprite).validateNow(); //TODO
						break;
				}
				
				y += element.height + _gap;
				
				if (element is IMarginedLayoutElement) y += (element as IMarginedLayoutElement).marginBottom;
			}
		}
	}
}