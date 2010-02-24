package com.destroytoday.timer {
	import com.destroytoday.events.EventDispatcherPlus;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.osflash.signals.Signal;

	[Event(name="open", type="flash.events.Event")]
	[Event(name="change", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * The AsyncLoop class spreads out large processes to prevent stalls in the framerate.
	 * @author Jonnie Hallman
	 */
	public class AsyncLoop {
		/**
		 * @private 
		 */		
		protected var _started:Signal = new Signal();
		
		/**
		 * @private 
		 */		
		protected var _changed:Signal = new Signal();
		
		/**
		 * @private 
		 */		
		protected var _completed:Signal = new Signal();
		
		/**
		 * @private 
		 */		
		protected var _cancelled:Signal = new Signal();
		
		/**
		 * The function to call with each tick of the loop.
		 * This function MUST return a Boolean indicating whether to continue the loop (false) or to complete it (true).
		 */
		public var callback:Function;

		/**
		 * The limit in milliseconds of each set of counts until it carries over to the next frame.
		 * @default 20
		 */
		public var timerLimit:int = 20;

		/**
		 * The limit of the loop count.
		 * Any value below 1 disables the limit.
		 * @default -1
		 */
		public var countLimit:int = -1;

		/**
		 * @private
		 */
		protected var _timerStart:int = -1;

		/**
		 * @private
		 */
		protected var _timerChange:int = -1;

		/**
		 * @private
		 */
		protected var _timerEnd:int = -1;

		/**
		 * @private
		 */
		protected var _currentCount:uint;

		/**
		 * @private
		 */
		protected var _frameCount:uint;

		/**
		 * @private
		 */
		protected var _running:Boolean;

		/**
		 * Instance used to listen to enterframe.
		 * @private
		 */
		protected var _shape:Shape = new Shape();

		/**
		 * Instantiates the AsyncLoop class.
		 */
		public function AsyncLoop(callback:Function = null, countLimit:int = -1, timerLimit:int = 20) {
			if (callback != null) {
				this.callback = callback;
			}

			if (countLimit > 0) {
				this.countLimit = countLimit;
			}

			if (timerLimit > 0) {
				this.timerLimit = timerLimit;
			}
		}
		
		/**
		 * Returns the Signal that dispatches when the loop starts. 
		 * @return 
		 */		
		public function get started():Signal {
			return _started;
		}
		
		/**
		 * Returns the Signal that dispatches when the loop changes. 
		 * @return 
		 */		
		public function get changed():Signal {
			return _changed;
		}
		
		/**
		 * Returns the Signal that dispatches when the loop completes. 
		 * @return 
		 */		
		public function get completed():Signal {
			return _completed;
		}
		
		/**
		 * Returns the Signal that dispatches when the loop is cancelled.
		 * @return 
		 */		
		public function get cancelled():Signal {
			return _cancelled;
		}

		/**
		 * Indicates if the loop is running.
		 * @return
		 */
		public function get running():Boolean {
			return _running;
		}

		/**
		 * Returns the current loop count.
		 * The loop count is the number of times the callback has been called.
		 * @return
		 */
		public function get currentCount():int {
			return _currentCount;
		}

		/**
		 * Return the current frame count.
		 * The frame count is the number of times the loop had to carry over to the next frame.
		 * @return
		 */
		public function get frameCount():int {
			return _frameCount;
		}

		/**
		 * Returns the duration of the loop.
		 * If the loop hasn't started yet, duration returns -1.
		 * If the loop is running, duration returns the running time.
		 * @return
		 */
		public function get duration():int {
			if (_timerStart != -1 && _timerEnd != -1) {
				return _timerEnd - _timerStart;
			} else if (_timerEnd == -1) {
				return _timerChange - _timerStart;
			}

			return -1;
		}

		/**
		 * Starts the loop.
		 * @param callback
		 * @param limitTimer
		 * @param limitLoop
		 * @throws Error if the callback function doesn't return a boolean
		 */
		public function start():void {
			_running = true;

			_timerStart = getTimer();
			
			_started.dispatch(this);

			_shape.addEventListener(Event.ENTER_FRAME, enterframeHandler, false, 0, true);
		}

		/**
		 * Pauses the loop.
		 */
		public function pause():void {
			_running = false;

			_shape.removeEventListener(Event.ENTER_FRAME, enterframeHandler);
		}

		/**
		 * Cancels the loop and resets the loop count.
		 */
		public function cancel():void {
			_running = false;
			_currentCount = 0;
			_timerStart = -1;
			_timerChange = -1;
			_timerEnd = -1;

			_shape.removeEventListener(Event.ENTER_FRAME, enterframeHandler);

			_cancelled.dispatch(this);
		}

		/**
		 * @private
		 */
		protected function complete():void {
			_running = false;

			_timerEnd = getTimer();

			_shape.removeEventListener(Event.ENTER_FRAME, enterframeHandler);

			_completed.dispatch(this);
		}

		/**
		 * Where the magic happens.
		 * @private
		 * @param event
		 */
		protected function enterframeHandler(event:Event):void {
			// update the timer
			_timerChange = getTimer();

			++_frameCount;

			// loop until the callback returns AsyncLoopAction.BREAK, currentCount exceeds countLimit or the process time exceeds timerLimit
			do {
				if (callback() == AsyncLoopAction.BREAK || countLimit > 0 && _currentCount >= countLimit) {
					complete();
					break;
				}

				++_currentCount;
			} while (getTimer() - _timerChange < timerLimit);

			_changed.dispatch(this);
		}
	}
}