package com.destroytoday.net
{
	import asunit.framework.TestCase;
	
	import flash.display.Bitmap;
	import flash.utils.setTimeout;

	public class BitmapCacheFactoryTest extends TestCase
	{
		//--------------------------------------------------------------------------
		//
		//  Constants
		//
		//--------------------------------------------------------------------------
		
		[Embed(source="test/icon.jpg", mimeType="image/png")]
		protected const icon:Class;
		
		protected const iconURL:String = "file:///Users/jhallman/Sites/Frink/DestroyFramework/embed/test/icon.jpg";

		protected const errorURL:String = "file:///Users/jhallman/Sites/Frink/DestroyFramework/embed/test/doesntexist.jpg";
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var factory:BitmapCacheFactory;
		
		protected var bitmapCache:BitmapCache;
		
		protected var bitmap:Bitmap;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function BitmapCacheFactoryTest(testMethod:String = null)
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
			factory = new BitmapCacheFactory();
			bitmap = new Bitmap();
		}

		override protected function tearDown():void
		{
			factory = null;
			bitmap = null;
			bitmapCache = null;
		}
		
		protected function presetBitmapCache():void
		{
			bitmapCache = new BitmapCache();
			
			bitmapCache.bitmapData = (new icon() as Bitmap).bitmapData;
			
			factory.setBitmapCache(iconURL, bitmapCache);
		}

		//--------------------------------------------------------------------------
		//
		//  Tests
		//
		//--------------------------------------------------------------------------
		
		public function testGettingUncachedBitmap():void
		{
			bitmapCache = factory.getBitmapCache(iconURL, bitmap);
			
			setTimeout(addAsync(function():void 
			{ 
				assertNotNull("bitmap loaded", bitmapCache.bitmapData);
				assertSame("bitmap injected", bitmapCache.bitmapData, bitmap.bitmapData);
			}, 1000), 500.0);
		}
		
		public function testSettingBitmapCacheManually():void
		{
			presetBitmapCache();
			
			assertTrue(factory.hasBitmapCache(bitmapCache));
		}
		
		public function testUnusedBitmapCacheDisposal():void
		{
			presetBitmapCache();
			factory.clean();
			
			assertFalse(factory.hasBitmapCache(bitmapCache));
		}
		
		public function testBitmapReferenceRemovalWithoutURL():void
		{
			presetBitmapCache();
			bitmapCache.addReference(bitmap);
			factory.removeReference(bitmap);
			
			assertNull("bitmap disposed", bitmap.bitmapData);
			assertFalse("bitmap reference removed", bitmapCache.hasReference(bitmap));
		}
		
		public function testBitmapReferenceRemovalWithURL():void
		{
			presetBitmapCache();
			bitmapCache.addReference(bitmap);
			factory.removeReference(bitmap, iconURL);
			
			assertNull("bitmap disposed", bitmap.bitmapData);
			assertFalse("bitmap reference removed", bitmapCache.hasReference(bitmap));
		}
		
		public function testDefaultBitmapDataInjectedBeforeLoadCompletes():void
		{
			factory.defaultBitmapData = (new icon() as Bitmap).bitmapData;
			
			bitmapCache = factory.getBitmapCache(iconURL, bitmap);
			
			assertSame(factory.defaultBitmapData, bitmapCache.bitmapData);
		}
		
		public function testDefaultBitmapDataRemainsAfterLoadError():void
		{
			factory.defaultBitmapData = (new icon() as Bitmap).bitmapData;
			
			bitmapCache = factory.getBitmapCache(errorURL, bitmap);
			
			setTimeout(addAsync(function():void 
			{ 
				assertSame(factory.defaultBitmapData, bitmapCache.bitmapData);
			}, 1000), 500.0);
		}
	}
}