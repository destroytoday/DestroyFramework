package com.destroytoday.pool {
	import flash.utils.Timer;

	public class TimerPool extends ObjectPool {
		public function TimerPool() {
			super(Timer);
		}

		override protected function constructObject():Object {
			return new Timer(0);
		}
	}
}