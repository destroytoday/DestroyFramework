package com.destroytoday.net
{
	import com.destroytoday.pool.ObjectPool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class BitmapCacheFactory
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var loaderPool:ObjectPool = new ObjectPool(Loader);
		
		protected var bitmapCachePool:ObjectPool = new ObjectPool(BitmapCache);
		
		protected var bitmapCacheList:Vector.<BitmapCache> = new Vector.<BitmapCache>();
		
		protected var bitmapCacheURLMap:Object = new Object(); // key = url
		
		protected var bitmapCacheLoaderMap:Dictionary = new Dictionary(); // key = loader
		
		protected var disposeTimer:Timer = new Timer(1800000.0); // half hour by default
		
		protected var _defaultBitmapData:BitmapData;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BitmapCacheFactory(defaultBitmapData:BitmapData = null)
		{
			_defaultBitmapData = defaultBitmapData;
			
			disposeTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			disposeTimer.start();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get numBitmapCaches():int
		{
			return bitmapCacheList.length;
		}
		
		public function get defaultBitmapData():BitmapData
		{
			return _defaultBitmapData;
		}
		
		public function set defaultBitmapData(value:BitmapData):void
		{
			if (value == _defaultBitmapData) return;
			
			_defaultBitmapData = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function getBitmapCache(url:String, bitmap:Bitmap = null):BitmapCache
		{
			var isLoading:Boolean;
			
			// get BitmapCache linked to url
			var bitmapCache:BitmapCache = bitmapCacheURLMap[url];
			
			// instantiate the BitmapCache if it doesn't exist
			if (!bitmapCache)
			{
				bitmapCache = bitmapCachePool.getObject() as BitmapCache;
				
				if (_defaultBitmapData) bitmapCache.bitmapData = _defaultBitmapData;
				
				addBitmapCache(bitmapCache, url);
			}
			else
			{
				isLoading = (bitmapCache.bitmapData == null || bitmapCache.bitmapData === _defaultBitmapData);
			}
			
			if (bitmap)
			{
				// remove bitmap's existing reference
				removeReference(bitmap);
				
				// add reference for automatic bitmapData injection
				bitmapCache.addReference(bitmap);
			}
			
			// 
			if (!isLoading)
			{
				var loader:Loader = loaderPool.getObject() as Loader;

				bitmapCacheLoaderMap[loader] = bitmapCache;
				
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, bitmapCacheLoaderCompleteHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bitmapCacheLoaderErrorHandler);
				
				loader.load(new URLRequest(url));
			}
			
			return bitmapCache;
		}
		
		public function setBitmapCache(url:String, bitmapCache:BitmapCache):BitmapCache
		{
			var oldBitmapCache:BitmapCache = bitmapCacheURLMap[url];
			
			if (oldBitmapCache) disposeBitmapCache(oldBitmapCache);
			
			addBitmapCache(bitmapCache, url);
			
			return bitmapCache;
		}
		
		public function removeReference(bitmap:Bitmap, url:String = null):Bitmap
		{
			var bitmapCache:BitmapCache;
			
			if (url)
			{
				bitmapCache = bitmapCacheURLMap[url];
			}

			if (!bitmapCache)
			{
				for each (bitmapCache in bitmapCacheList)
				{
					if (bitmapCache.hasReference(bitmap))
					{
						break;
					}
					else
					{
						bitmapCache = null;
					}
				}
			}
			
			if (bitmapCache)
			{
				bitmapCache.removeReference(bitmap);
			}
			
			return bitmap;
		}
		
		public function clean():void
		{
			for each (var bitmapCache:BitmapCache in bitmapCacheURLMap)
			{
				if (bitmapCache.numReferences == 0)
				{
					disposeBitmapCache(bitmapCache);
				}
			}
		}
		
		public function hasBitmapCache(bitmapCache:BitmapCache):Boolean
		{
			return bitmapCacheList.indexOf(bitmapCache) != -1;
		}
		
		protected function addBitmapCache(bitmapCache:BitmapCache, url:String = null):BitmapCache
		{
			if (bitmapCacheList.indexOf(bitmapCache) == -1)
			{
				if (url) bitmapCache.url = url;
				
				bitmapCacheList[bitmapCacheList.length] = bitmapCache;
				bitmapCacheURLMap[bitmapCache.url] = bitmapCache;
			}
			
			return bitmapCache;
		}
		
		protected function disposeBitmapCache(bitmapCache:BitmapCache):BitmapCache
		{
			delete bitmapCacheURLMap[bitmapCache.url];
			
			var index:int = bitmapCacheList.indexOf(bitmapCache);
			
			if (index != -1) bitmapCacheList.splice(index, 1);
			
			bitmapCachePool.disposeObject(bitmapCache);
			
			return bitmapCache;
		}
		
		protected function disposeLoader(loader:Loader):void
		{
			delete bitmapCacheLoaderMap[loader];
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bitmapCacheLoaderCompleteHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, bitmapCacheLoaderErrorHandler);
			
			loader.unload();
			loaderPool.disposeObject(loader);
		}
		
		protected function processBitmap(bitmap:Bitmap):Bitmap
		{
			return bitmap;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function bitmapCacheLoaderCompleteHandler(event:Event):void
		{
			var loader:Loader = (event.currentTarget as LoaderInfo).loader;
			var bitmapCache:BitmapCache = bitmapCacheLoaderMap[loader];
			var bitmap:Bitmap = processBitmap(loader.content as Bitmap);
			
			bitmapCache.bitmapData = bitmap.bitmapData;
			
			disposeLoader(loader);
		}
		
		protected function bitmapCacheLoaderErrorHandler(event:IOErrorEvent):void 
		{
			trace(event);
			disposeLoader((event.currentTarget as LoaderInfo).loader);
		}
		
		protected function timerHandler(event:TimerEvent):void
		{
			clean();
		}
	}
}