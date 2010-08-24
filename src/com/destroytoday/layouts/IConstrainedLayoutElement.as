package com.destroytoday.layouts {

	public interface IConstrainedLayoutElement extends IBasicLayoutElement {
		function get left():Number;
		function set left(value:Number):void;
		
		function get top():Number;
		function set top(value:Number):void;
		
		function get right():Number;
		function set right(value:Number):void;
		
		function get bottom():Number;
		function set bottom(value:Number):void;
		
		function get center():Number;
		function set center(value:Number):void;
		
		function get middle():Number;
		function set middle(value:Number):void;
	}
}