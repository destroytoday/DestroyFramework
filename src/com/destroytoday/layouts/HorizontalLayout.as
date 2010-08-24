package com.destroytoday.layouts
{
	import com.destroytoday.display.IGroup;
	import com.destroytoday.display.InvalidationSprite;

	public class HorizontalLayout extends BasicLayout
	{
		protected var _verticalAlign:String;
		
		protected var _gap:Number = 0.0;
		
		public function HorizontalLayout()
		{
		}
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign(value:String):void
		{
			_verticalAlign = value;
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
			var x:Number;
			
			var m:uint = group.numElements;

			x = _paddingLeft;
			
			//TODO - apply top/bottom margin
			
			for (var i:uint = 0; i < m; ++i) {
				element = group.getElementAt(i);
				
				if (!element || (element is INonLayoutElement && !(element as INonLayoutElement).includeInLayout)) continue;
				
				if (element is IMarginedLayoutElement) x += (element as IMarginedLayoutElement).marginLeft;
				
				if (element is InvalidationSprite) (element as InvalidationSprite).validateNow();
				
				element.x = x;

				switch (_verticalAlign) {
					case VerticalAlignType.TOP:
						element.y = _paddingTop;
						break;
					case VerticalAlignType.MIDDLE:
						element.y = _paddingTop + (group.height - (_paddingTop + _paddingBottom + element.height)) * 0.5;
						break;
					case VerticalAlignType.BOTTOM:
						element.y = group.height - (_paddingBottom + element.height);
						break;
					case VerticalAlignType.JUSTIFY:
						element.y = _paddingTop;
						element.height = group.height - (_paddingTop + _paddingBottom);
						
						if (element is InvalidationSprite) (element as InvalidationSprite).validateNow();
						break;
				}
					
				x += element.width + _gap;
				
				if (element is IMarginedLayoutElement) x += (element as IMarginedLayoutElement).marginRight;
			}
		}
	}
}