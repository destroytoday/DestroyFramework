package com.destroytoday.display {
	import com.destroytoday.layouts.IBasicLayoutElement;

	public interface IGroup {
		function get width():Number;
		function get height():Number;
		function get numElements():int;
		
		function getElementAt(index:int):IBasicLayoutElement;
	}
}