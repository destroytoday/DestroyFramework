package com.destroytoday.layouts {
	public interface INonLayoutElement extends IBasicLayoutElement {
		function get includeInLayout():Boolean;
		function set includeInLayout(value:Boolean):void;
	}
}