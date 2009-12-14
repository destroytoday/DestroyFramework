package com.destroytoday.desktop {
	import com.destroytoday.events.ScreenMonitorEvent;
	
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="screens_change", type="com.destroytoday.events.ScreenMonitorEvent")]

	/**
	 * The ScreenMonitor class notifies when screens are connected or disconnected.
	 * @author Jonnie Hallman
	 */	
	public class ScreenMonitor extends EventDispatcher {
		/**
		 * @private 
		 */		
		protected static var screens:uint;
		
		/**
		 * @private 
		 */		
		protected static var token:int;
		
		/**
		 * @private 
		 */		
		protected static var instantiating:Boolean;
		
		/**
		 * @private 
		 */		
		protected static var _monitor:ScreenMonitor;
		
		/**
		 * @private 
		 */		
		protected static var _timer:Timer;
		
		/**
		 * @private 
		 */		
		protected static var _pollInterval:int = 5000;
		
		/**
		 * Indicates whether the ScreenMonitor is actively running or not. 
		 * @return 
		 */		
		public static function get running():Boolean { return timer.running; }
		
		/**
		 * The amount of time, in milliseconds, between polls. 
		 * @return 
		 */		
		public static function get pollInterval():int { return _pollInterval; }
		
		/**
		 * @param value
		 */		
		public static function set pollInterval(value:int):void {
			timer.delay = _pollInterval = value;
			
			if (!timer.running) start();
		}
		
		/**
		 * @private
		 */		
		public function ScreenMonitor():void {
			if (!instantiating) {
				throw new Error("The ScreenMonitor class cannot be instantiated.");
			} else {
				instantiating = false;
			}
		}
		
		/**
		 * @private 
		 * @return 
		 */		
		protected static function get monitor():ScreenMonitor {
			if (!_monitor) {
				instantiating = true;
				
				_monitor = new ScreenMonitor();
			}
			
			return _monitor;
		}
		
		/**
		 * @private 
		 * @return 
		 */		
		protected static function get timer():Timer {
			if (!_timer) {
				_timer = new Timer(_pollInterval);
				
				_timer.addEventListener(TimerEvent.TIMER, pollHandler);
			}
			
			return _timer;
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void {
			monitor.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			monitor.removeEventListener(type, listener, useCapture);
		}
		public static function hasEventListener(type:String):Boolean {
			return monitor.hasEventListener(type);
		}
		public static function willTrigger(type:String):Boolean {
			return monitor.willTrigger(type);
		}
		public static function dispatchEvent(event:Event):Boolean {
			if (monitor.hasEventListener(event.type) || event.bubbles) {
				return monitor.dispatchEvent(event);
			}

			return true;
		}
		
		/**
		 * Starts the ScreenMonitor.
		 */		
		public static function start():void {
			screens = Screen.screens.length;
			
			timer.start();
		}
		
		/**
		 * Stops the ScreenMonitor.
		 */		
		public static function stop():void {
			timer.reset();
		}
		
		/**
		 * Manually checks whether the number of screens changed.
		 * If the monitor is running, the timer will reset and continue polling.
		 */		
		public static function check():void {
			_check();
			
			if (timer.running) {
				timer.reset();
				timer.start();
			}
		}
		
		/**
		 * @private
		 */		
		protected static function _check():void {
			var _screens:uint = Screen.screens.length;
			
			if (screens != _screens) {
				var event:ScreenMonitorEvent = new ScreenMonitorEvent(ScreenMonitorEvent.SCREENS_CHANGE);
				
				event.oldScreens = screens;
				event.newScreens = _screens;
				
				screens = _screens;
				
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private 
		 * @param event
		 */		
		protected static function pollHandler(event:TimerEvent):void { _check(); }
	}
}