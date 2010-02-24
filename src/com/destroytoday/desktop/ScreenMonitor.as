package com.destroytoday.desktop {
	import com.destroytoday.events.ScreenMonitorEvent;
	
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	
	/**
	 * The ScreenMonitor class notifies when screens are connected or disconnected.
	 * @author Jonnie Hallman
	 */	
	public class ScreenMonitor {
		/**
		 * @private 
		 */		
		protected var _screensChanged:Signal = new Signal(Array, Array);
		
		/**
		 * @private 
		 */		
		protected var screens:Array;
		
		/**
		 * @private 
		 */		
		protected var _timer:Timer;
		
		/**
		 * @private 
		 */		
		protected var _pollInterval:int = 5000;
		
		/**
		 * @private
		 */		
		public function ScreenMonitor():void {
			_timer = new Timer(_pollInterval);
			
			_timer.addEventListener(TimerEvent.TIMER, pollHandler);
		}
		
		/**
		 * Returns the Signal that dispatches when the screens change.
		 * The handler arguments are (oldScreens:Array, newScreens:Array) 
		 * @return 
		 */		
		public function get screensChanged():Signal {
			return _screensChanged;
		}
		
		/**
		 * Indicates whether the ScreenMonitor is actively running or not. 
		 * @return 
		 */		
		public function get running():Boolean { return _timer.running; }
		
		/**
		 * The amount of time, in milliseconds, between polls. 
		 * @return 
		 */		
		public function get pollInterval():int { return _pollInterval; }
		
		/**
		 * @param value
		 */		
		public function set pollInterval(value:int):void {
			_timer.delay = _pollInterval = value;
			
			if (!_timer.running) start();
		}
		
		/**
		 * Starts the ScreenMonitor.
		 */		
		public function start():void {
			screens = Screen.screens;
			
			_timer.start();
		}
		
		/**
		 * Stops the ScreenMonitor.
		 */		
		public function stop():void {
			_timer.reset();
		}
		
		/**
		 * Manually checks whether the number of screens changed.
		 * If the monitor is running, the timer will reset and continue polling.
		 */		
		public function check():void {
			_check();
			
			if (_timer.running) {
				_timer.reset();
				_timer.start();
			}
		}
		
		/**
		 * @private
		 */		
		protected function _check():void {
			var newScreens:Array = Screen.screens;
			
			if (newScreens.length != screens.length) {
				var oldScreens:Array = screens;
				
				screens = newScreens;
				
				_screensChanged.dispatch(oldScreens, newScreens);
			}
		}
		
		/**
		 * @private 
		 * @param event
		 */		
		protected function pollHandler(event:TimerEvent):void { _check(); }
	}
}