package com.destroytoday.net {
	public class URLParameter {
		public var name:String;
		public var value:String;
		
		public function URLParameter(name:String = null, value:String = null) {
			this.name = name;
			this.value = value;
		}
		
		public function toString():String {
			return name + "=" + value;
		}
		
		public function dispose():void {
			name = null;
			value = null;
		}
	}
}