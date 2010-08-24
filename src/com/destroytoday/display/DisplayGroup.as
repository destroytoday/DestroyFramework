package com.destroytoday.display
{
	import com.destroytoday.layouts.BasicLayout;
	import com.destroytoday.layouts.HorizontalLayout;
	import com.destroytoday.layouts.IBasicLayoutElement;
	import com.destroytoday.layouts.VerticalAlignType;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DisplayGroup extends SpritePlus implements IGroup
	{
		protected var _layout:BasicLayout;
		
		public function DisplayGroup(layout:BasicLayout = null)
		{
			_layout = layout;
			
			if (!_layout) {
				_layout = new BasicLayout();
			}
			
			addEventListener(Event.ADDED, addedHandler);
			addEventListener(Event.REMOVED, removedHandler);
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function get layout():BasicLayout
		{
			return _layout;
		}

		public function set layout(value:BasicLayout):void
		{
			if (value == _layout) return;
			
			_layout = value;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList():void 
		{
			super.updateDisplayList();
			
			_layout.updateDisplayList(this);
		}
		
		public function get numElements():int
		{
			return numChildren;
		}
		
		public function getElementAt(index:int):IBasicLayoutElement
		{
			return getChildAt(index) as IBasicLayoutElement;
		}
		
		protected function addedHandler(event:Event):void
		{
			invalidateDisplayList();
		}
		
		protected function removedHandler(event:Event):void
		{
			invalidateDisplayList();
		}
	}
}