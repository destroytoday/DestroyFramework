package com.destroytoday.pool {
	import flash.utils.Timer;

	public class TimerPool extends ObjectPool {
		public function TimerPool() {
			super(Timer);

			instantiator = _instantiator;
		}

		protected function _instantiator():Object {
			return new Timer(0);
		}
	}
}