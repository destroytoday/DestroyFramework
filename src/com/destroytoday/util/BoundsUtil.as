package com.destroytoday.util
{
	import flash.geom.Rectangle;

	public class BoundsUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BoundsUtil()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public static function getBoundsFitWithin(objectBounds:Rectangle, containerBounds:Rectangle, upscale:Boolean = false, recycledBounds:Rectangle = null):Rectangle
		{
			var fittedBounds:Rectangle = recycledBounds || new Rectangle();
			
			if (objectBounds.width / objectBounds.height > containerBounds.width / containerBounds.height)
			{
				fittedBounds.width = (!upscale && containerBounds.width > objectBounds.width) ? objectBounds.width : containerBounds.width;
				fittedBounds.height = fittedBounds.width * (objectBounds.height / objectBounds.width);
			}
			else if (objectBounds.width / objectBounds.height < containerBounds.width / containerBounds.height)
			{
				fittedBounds.height = (!upscale && containerBounds.height > objectBounds.height) ? objectBounds.height : containerBounds.height;
				fittedBounds.width = fittedBounds.height * (objectBounds.width / objectBounds.height);
			}
			else
			{
				fittedBounds.width = (!upscale && containerBounds.width > objectBounds.width) ? objectBounds.width : containerBounds.width;
				fittedBounds.height = (!upscale && containerBounds.height > objectBounds.height) ? objectBounds.height : containerBounds.height;
			}
			
			return fittedBounds;
		}
	}
}