package com.destroytoday.events {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class EventDispatcherPlus extends EventDispatcher {
		public function EventDispatcherPlus(target:IEventDispatcher = null) {
			super(target);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true) : void {
			super.addEventListener(type, listener);
		}
		
		override public function dispatchEvent(event:Event):Boolean {
			if (hasEventListener(event.type)) {
				return super.dispatchEvent(event);
			}
			
			return false;
		}
	}
}