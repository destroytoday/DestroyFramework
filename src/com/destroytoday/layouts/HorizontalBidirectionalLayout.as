package com.destroytoday.layouts
{
	import com.destroytoday.display.IGroup;
	import com.destroytoday.display.InvalidationSprite;

	public class HorizontalBidirectionalLayout extends HorizontalLayout
	{
		override public function updateDisplayList(group:IGroup):void
		{
			var element:IAlignedLayoutElement;
			var leftX:Number, rightX:Number;
			
			var m:uint = group.numElements;

			leftX = _paddingLeft;
			rightX = group.width - _paddingRight;
			
			//TODO apply top/bottom margin
			
			for (var i:uint = 0; i < m; ++i) {
				element = group.getElementAt(i) as IAlignedLayoutElement;
				
				if (!element || (element is INonLayoutElement && !(element as INonLayoutElement).includeInLayout)) continue;
				
				if (element is InvalidationSprite) (element as InvalidationSprite).validateNow();
				
				if (element.align == HorizontalAlignType.LEFT) {
					if (element is IMarginedLayoutElement) {
						leftX += (element as IMarginedLayoutElement).marginLeft;
					}
					
					element.x = leftX;
				} else if (element.align == HorizontalAlignType.RIGHT) {
					if (element is IMarginedLayoutElement) {
						rightX -= (element as IMarginedLayoutElement).marginRight;
					}
					
					rightX -= element.width;
					
					element.x = rightX;
				}
				
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
				
				if (element.align == HorizontalAlignType.LEFT) {
					if (element is IMarginedLayoutElement) {
						leftX += (element as IMarginedLayoutElement).marginRight;
					}
					
					leftX += element.width + _gap;
				} else if (element.align == HorizontalAlignType.RIGHT) {
					if (element is IMarginedLayoutElement) {
						rightX -= (element as IMarginedLayoutElement).marginLeft;
					}
					
					rightX -= _gap;
				}
			}
		}
	}
}