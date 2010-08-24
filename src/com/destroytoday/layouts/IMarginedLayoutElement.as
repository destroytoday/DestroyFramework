package com.destroytoday.layouts {

	public interface IMarginedLayoutElement extends IBasicLayoutElement {
		function get marginLeft():Number;
		function set marginLeft(value:Number):void;
		
		function get marginTop():Number;
		function set marginTop(value:Number):void;
		
		function get marginRight():Number;
		function set marginRight(value:Number):void;
		
		function get marginBottom():Number;
		function set marginBottom(value:Number):void;
	}
}