package com.destroytoday.util
{
	import flash.utils.Dictionary;

	public class ObjectMap extends Dictionary
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ObjectMap(weakKeys:Boolean = false)
		{
			super(weakKeys);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function mapValue(key:Object, value:Object):*
		{
			this[key] = value;
			
			return value;
		}
		
		public function unmapValue(key:Object):*
		{
			var value:Object = this[key];
			
			delete this[key];
			
			return value;
		}
	}
}