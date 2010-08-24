package com.destroytoday.util
{
	import com.destroytoday.vo.ColorVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class ColorUtil
	{
		public function ColorUtil()
		{
		}
		
		public static function getRGB(color:uint):ColorVO {
			var rgb:ColorVO = new ColorVO();
			
			rgb.hex = color;
			rgb.red = color >> 16;
			rgb.green = (color >> 8) & 0xFF;
			rgb.blue = color & 0xFF;
			
			return rgb;
		}
		
		public static function getHex(red:uint, green:uint, blue:uint):ColorVO
		{
			var color:ColorVO = new ColorVO();
			
			color.hex = red << 16 | green << 8 | blue; 
			color.red = red;
			color.green = green;
			color.blue = blue;
			
			return color;
		}
		
		public static function formatHex(hex:uint, prefix:String = '0x'):String
		{
			return prefix + hex.toString(16);
		}
		
		public static function apply(target:DisplayObject, color:uint):void
		{
			var rgb:ColorVO = getRGB(color);

			var transform:ColorTransform = new ColorTransform(1, 1, 1, 1, rgb.red, rgb.green, rgb.blue);

			target.transform.colorTransform = transform;
		}
	}
}