package com.destroytoday.net
{
	import asunit.framework.TestCase;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class BitmapCacheTest extends TestCase
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var bitmapCache:BitmapCache;
		
		protected var bitmap:Bitmap;
		
		protected var bitmap1:Bitmap;
		
		protected var bitmap2:Bitmap;
		
		protected var bitmapData:BitmapData;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BitmapCacheTest(testMethod:String = null)
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
			bitmapCache = new BitmapCache();
			bitmap = new Bitmap();
			bitmap1 = new Bitmap();
			bitmap2 = new Bitmap();
			bitmapData = new BitmapData(600.0, 400.0);
		}
		
		override protected function tearDown():void
		{
			bitmapCache = null;
			bitmap = null;
			bitmap1 = null;
			bitmap2 = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Tests
		//
		//--------------------------------------------------------------------------
		
		public function testReferenceAddition():void
		{
			bitmapCache.addReference(bitmap);
			
			assertTrue(bitmapCache.hasReference(bitmap));
		}
		
		public function testSingleReferenceRemoval():void
		{
			bitmapCache.bitmapData = bitmapData;
			
			bitmapCache.addReference(bitmap);
			bitmapCache.addReference(bitmap1);
			bitmapCache.addReference(bitmap2);
			
			bitmapCache.removeReference(bitmap);
			
			assertFalse("Reference removed", bitmapCache.hasReference(bitmap));
			assertNull("Reference bitmapData nullified", bitmap.bitmapData);
			assertTrue("Other references still intact",
				bitmapCache.hasReference(bitmap1) && 
				bitmapCache.hasReference(bitmap2));
			assertTrue("Other reference bitmapData still intact", 
				bitmap1.bitmapData &&
				bitmap2.bitmapData);
		}
		
		public function testAllReferenceRemoval():void
		{
			bitmapCache.addReference(bitmap);
			bitmapCache.addReference(bitmap1);
			bitmapCache.addReference(bitmap2);
			
			bitmapCache.removeAllReferences();
			
			assertFalse("References removed",
				bitmapCache.hasReference(bitmap) && 
				bitmapCache.hasReference(bitmap1) && 
				bitmapCache.hasReference(bitmap2));
			assertFalse("References bitmapData nullified",
				bitmap.bitmapData &&
				bitmap1.bitmapData &&
				bitmap2.bitmapData);
		}
		
		public function testReferenceCount():void
		{
			bitmapCache.addReference(bitmap);
			bitmapCache.addReference(bitmap1);
			bitmapCache.addReference(bitmap2);
			
			assertEquals(3, bitmapCache.numReferences);
		}
		
		public function testReferenceInjectionUponSettingBitmapData():void
		{
			bitmapCache.addReference(bitmap);
			bitmapCache.addReference(bitmap1);
			bitmapCache.addReference(bitmap2);
			
			bitmapCache.bitmapData = bitmapData;
			
			assertTrue(
				bitmap.bitmapData === bitmapData &&
				bitmap1.bitmapData === bitmapData &&
				bitmap2.bitmapData === bitmapData);
		}
		
		public function testReferenceInjectionUponAddingReference():void
		{
			bitmapCache.bitmapData = bitmapData;
			
			bitmapCache.addReference(bitmap);
			
			assertTrue(bitmap.bitmapData === bitmapData);
		}
		
		public function testDisposal():void
		{
			bitmapCache.addReference(bitmap);
			
			bitmapCache.url = "image.jpg";
			bitmapCache.bitmapData = bitmapData;
			
			bitmapCache.dispose();

			assertNull("url nullified", bitmapCache.url);
			assertNull("bitmapData nullified", bitmapCache.bitmapData);
			assertEquals("References wiped", 0, bitmapCache.numReferences);
			assertThrows(Error, function():void { bitmapData.width; });
		}
	}
}