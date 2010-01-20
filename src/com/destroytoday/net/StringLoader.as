package com.destroytoday.net {
	import org.osflash.signals.Signal;
	
	/**
	 * The StringLoader class improves upon the URLLoader class, including additional features and Signal support.
	 * @author Jonnie Hallman
	 */	
	public class StringLoader extends GenericLoader {
		public function StringLoader() {
		}
		
		private var _data:String;
		
		public function get data():String {
			return _data;
		}

		override protected function instantiateSignals():void {
			_openSignal = new Signal(StringLoader);
			_completeSignal = new Signal(StringLoader, String);
			_errorSignal = new Signal(StringLoader, String, String);
			_cancelSignal = new Signal(StringLoader);
		}
		
		override protected function parseData(data:*):Boolean {
			_data = data;
			
			return true;
		}
		
		override protected function dispatchData():void {
			_completeSignal.dispatch(this, _data);
		}
		
		override protected function disposeData():void {
			_data = null;
		}
	}
}