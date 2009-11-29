package com.destroytoday.events {
	import flash.events.Event;
	
	public class ScreenMonitorEvent extends Event {
		public static const SCREENS_CHANGE:String = "ScreenMonitorEventScreensChange";
		
		public var oldScreens:uint;
		public var newScreens:uint;
		
		public function ScreenMonitorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}