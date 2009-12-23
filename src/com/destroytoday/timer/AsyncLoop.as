package com.destroytoday.timer {
	import com.destroytoday.events.EventDispatcherPlus;

	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	[Event(name="open", type="flash.events.Event")]
	[Event(name="change", type="flash.events.Event")]
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * The AsyncLoop class spreads out large processes to prevent stalls in the framerate.
	 * @author Jonnie Hallman
	 */
	public class AsyncLoop extends EventDispatcherPlus {
		/**
		 * @private
		 */
		protected var _callback:Function;

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
		protected var _timerLimit:int;

		/**
		 * @private
		 */
		protected var _countLimit:int;

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
				_callback = callback;
			}

			if (countLimit > 0) {
				_countLimit = countLimit;
			}

			if (timerLimit > 0) {
				_timerLimit = timerLimit;
			}
		}

		/**
		 * The function to call with each tick of the loop.
		 * This function MUST return a Boolean indicating whether to continue the loop (false) or to complete it (true).
		 * @return
		 */
		public function get callback():Function {
			return _callback;
		}

		/**
		 * @private
		 * @param value
		 */
		public function set callback(value:Function):void {
			_callback = value;
		}

		/**
		 * The limit in milliseconds of each set of counts until it carries over to the next frame.
		 * @return
		 * @default 20
		 */
		public function get timerLimit():int {
			return _timerLimit;
		}

		/**
		 * @private
		 * @param value
		 */
		public function set timerLimit(value:int):void {
			_timerLimit = value;
		}

		/**
		 * The limit of the loop count.
		 * Any value below 1 disables the limit.
		 * @default -1
		 * @return
		 */
		public function get countLimit():int {
			return _countLimit
		}

		/**
		 * @private
		 * @param value
		 */
		public function set countLimit(value:int):void {
			_countLimit = value;
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

			if (hasEventListener(Event.OPEN)) {
				dispatchEvent(new Event(Event.OPEN));
			}

			_timerStart = getTimer();

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

			if (hasEventListener(Event.CANCEL)) {
				dispatchEvent(new Event(Event.CANCEL));
			}
		}

		/**
		 * @private
		 */
		protected function complete():void {
			_running = false;

			_timerEnd = getTimer();

			_shape.removeEventListener(Event.ENTER_FRAME, enterframeHandler);

			if (hasEventListener(Event.COMPLETE)) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
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

			// loop until the callback returns AsyncLoopAction.END, currentCount exceeds countLimit or the process time exceeds timerLimit
			do {
				if (_callback() == AsyncLoopAction.END || _countLimit > 0 && _currentCount >= _countLimit) {
					complete();
					break;
				}

				++_currentCount;
			} while (getTimer() - _timerChange < _timerLimit);

			if (hasEventListener(Event.CHANGE)) {
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}