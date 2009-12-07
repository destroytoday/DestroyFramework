package com.destroytoday.events {
	import flash.events.Event;
	
	public class ScreenCaptureEvent extends Event {
		public static const CAPTURE:String = "ScreenCaptureEventCapture";
		
		public var storageType:String;
		public var path:String;
		public var url:String;
		
		public function ScreenCaptureEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}