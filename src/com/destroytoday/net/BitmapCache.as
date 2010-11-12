package com.destroytoday.net
{
	import com.destroytoday.core.IDisposable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class BitmapCache implements IDisposable
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _bitmapData:BitmapData;
		
		protected var _referenceList:Vector.<Bitmap> = new Vector.<Bitmap>();
		
		protected var _url:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BitmapCache()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			if (value == _url) return;
			
			_url = value;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void
		{
			if (value == _bitmapData) return;
			
			_bitmapData = value;
			
			for each (var bitmap:Bitmap in _referenceList)
			{
				bitmap.bitmapData = _bitmapData;
			}
		}
		
		public function get numReferences():int
		{
			return _referenceList.length;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addReference(bitmap:Bitmap):Bitmap
		{
			if (_referenceList.indexOf(bitmap) == -1)
			{
				_referenceList[_referenceList.length] = bitmap;
				
				if (_bitmapData) bitmap.bitmapData = _bitmapData;
			}
			
			return bitmap;
		}
		
		public function removeReference(bitmap:Bitmap):Bitmap
		{
			var index:int = _referenceList.indexOf(bitmap);
			
			if (index != -1)
			{
				bitmap.bitmapData = null;
				
				_referenceList.splice(index, 1);
			}
			
			return bitmap;
		}
		
		public function removeAllReferences():void
		{
			for each (var bitmap:Bitmap in _referenceList)
			{
				bitmap.bitmapData = null;
			}
			
			_referenceList.length = 0;
		}
		
		public function hasReference(bitmap:Bitmap):Boolean
		{
			return _referenceList.indexOf(bitmap) != -1;
		}
		
		public function dispose():void
		{
			removeAllReferences();
			
			if (_bitmapData) _bitmapData.dispose();
			
			_bitmapData = null;
			_url = null;
		}
	}
}