package com.destroytoday.util
{
	import asunit.framework.TestCase;
	
	import flash.display.Sprite;
	
	import org.flexunit.asserts.assertStrictlyEquals;
	
	public class ObjectMapTest extends TestCase
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var map:ObjectMap;
		
		protected var key:Object;
		
		protected var value:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ObjectMapTest(testMethod:String=null)
		{
			super(testMethod);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Prep
		//
		//--------------------------------------------------------------------------
		
		override protected function setUp():void
		{
			map = new ObjectMap();
			key = {name: "key"};
			value = {name: "value"};
		}
		
		override protected function tearDown():void
		{
			map = null;
			key = null;
			value = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Tests
		//
		//--------------------------------------------------------------------------
		
		public function testMapValueWithKey():void
		{
			map.mapValue(key, value);
			
			assertEquals(value, map[key]);
		}
		
		public function testUnmapValueWithKey():void
		{
			map.mapValue(key, value);
			map.unmapValue(key);
			
			assertNull(map[key]);
		}
		
		public function testMapValueReturnsValue():void
		{
			var value2:Object = map.mapValue(key, value);
			
			assertStrictlyEquals(value, value2);
		}
		
		public function testUnmapValueReturnsValue():void
		{
			map.mapValue(key, value);
			var value2:Object = map.unmapValue(key);
			
			assertStrictlyEquals(value, value2);
		}
	}
}