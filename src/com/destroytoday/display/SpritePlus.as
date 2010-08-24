package com.destroytoday.display
{
	import com.destroytoday.layouts.IAlignedLayoutElement;
	import com.destroytoday.layouts.IConstrainedLayoutElement;
	import com.destroytoday.layouts.IMarginedLayoutElement;
	import com.destroytoday.layouts.INonLayoutElement;
	
	public class SpritePlus extends InvalidationSprite implements IConstrainedLayoutElement, IMarginedLayoutElement, INonLayoutElement
	{
		protected var _explicitWidth:Number;
		
		protected var _explicitHeight:Number;
		
		protected var _left:Number;
		
		protected var _top:Number;
		
		protected var _right:Number;
		
		protected var _bottom:Number;
		
		protected var _center:Number;
		
		protected var _middle:Number;
		
		protected var _marginLeft:Number = 0.0;
		
		protected var _marginTop:Number = 0.0;
		
		protected var _marginRight:Number = 0.0;
		
		protected var _marginBottom:Number = 0.0;
		
		protected var _includeInLayout:Boolean = true;
		
		public function SpritePlus()
		{
		}

		public function get includeInLayout():Boolean
		{
			return _includeInLayout;
		}

		public function set includeInLayout(value:Boolean):void
		{
			_includeInLayout = value;
		}

		override public function get width():Number 
		{
			if (_explicitWidth < 0 || _explicitWidth >= 0) return _explicitWidth;
			
			return super.width;
		}
		
		override public function set width(value:Number):void
		{
			if (value == _explicitWidth) return;
			
			_explicitWidth = value;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		override public function get height():Number 
		{
			if (_explicitHeight < 0 || _explicitHeight >= 0) return _explicitHeight;
			
			return super.height;
		}
		
		override public function set height(value:Number):void
		{
			if (value == _explicitHeight) return;
			
			_explicitHeight = value;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		public function get measuredWidth():Number
		{
			return super.width;
		}
		
		public function get measuredHeight():Number
		{
			return super.height;
		}
		
		public function get left():Number
		{
			return _left;
		}
		
		public function set left(value:Number):void
		{
			_left = value;
		}
		
		public function get top():Number
		{
			return _top;
		}
		
		public function set top(value:Number):void
		{
			_top = value;
		}
		
		public function get right():Number
		{
			return _right;
		}
		
		public function set right(value:Number):void
		{
			_right = value;
		}
		
		public function get bottom():Number
		{
			return _bottom;
		}
		
		public function set bottom(value:Number):void
		{
			_bottom = value;
		}
		
		public function get center():Number
		{
			return _center;
		}
		
		public function set center(value:Number):void
		{
			_center = value;
		}
		
		public function get middle():Number
		{
			return _middle;
		}
		
		public function set middle(value:Number):void
		{
			_middle = value;
		}
		
		public function get marginLeft():Number
		{
			return _marginLeft;
		}
		
		public function set marginLeft(value:Number):void
		{
			_marginLeft = value;
		}
		
		public function get marginTop():Number
		{
			return _marginTop;
		}
		
		public function set marginTop(value:Number):void
		{
			_marginTop = value;
		}
		
		public function get marginRight():Number
		{
			return _marginRight;
		}
		
		public function set marginRight(value:Number):void
		{
			_marginRight = value;
		}
		
		public function get marginBottom():Number
		{
			return _marginBottom;
		}
		
		public function set marginBottom(value:Number):void
		{
			_marginBottom = value;
		}
		
		public function setConstraints(left:Number, top:Number, right:Number, bottom:Number):void
		{
			_left = left;
			_top = top;
			_right = right;
			_bottom = bottom;
		}
		
		public function setMargins(left:Number, top:Number, right:Number, bottom:Number):void
		{
			_marginLeft = left;
			_marginTop = top;
			_marginRight = right;
			_marginBottom = bottom;
		}
	}
}