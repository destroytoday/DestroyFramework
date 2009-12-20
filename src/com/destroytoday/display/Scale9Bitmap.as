package com.destroytoday.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * The Scale9Bitmap class scales a bitmap based on a scale 9 grid.
	 * @author Jonnie Hallman
	 */	
	public class Scale9Bitmap extends Sprite {
		/**
		 * @private 
		 */		
		protected var _bitmapData:BitmapData;
		
		/**
		 * @private 
		 */		
		protected var _scale9Grid:Rectangle;
		
		/**
		 * A (0,0) Point required by bitmapData.copy().
		 * @private 
		 */		
		protected var point:Point = new Point();
		
		/**
		 * @private 
		 */		
		protected var _width:Number = 0.0;
		
		/**
		 * @private 
		 */		
		protected var _height:Number = 0.0;
		
		/**
		 * @private 
		 */		
		protected var _scaleX:Number = 1.0;

		/**
		 * @private 
		 */	
		protected var _scaleY:Number = 1.0;
		
		/**
		 * @private 
		 */	
		protected var scaledWidth:Number = 0.0;
		
		/**
		 * @private 
		 */	
		protected var scaledHeight:Number = 0.0;
		
		/**
		 * A vector of the Bitmaps used to make up the scale 9 grid.
		 * @private 
		 */	
		protected var bitmaps:Vector.<Bitmap> = new Vector.<Bitmap>();
		
		/**
		 * A vector of the Rectangles used to copy the BitmapData from the Bitmap to the grid Bitmaps.
		 * @private 
		 */	
		protected var rects:Vector.<Rectangle> = new Vector.<Rectangle>();
		
		/**
		 * Instantiates the Scale9Bitmap class.
		 */		
		public function Scale9Bitmap() {
			var m:uint = 9;
			
			// instantiate the Bitmaps and Rectangle cells
			for (var i:uint = 0; i < m; ++i) {
				bitmaps[bitmaps.length] = addChild(new Bitmap()) as Bitmap;
				rects[rects.length] = new Rectangle();
			}
		}
		
		/**
		 * @inerhitDoc 
		 */		
		override public function get width():Number {
			return _width;
		}
		
		/**
		 * @private
		 * @param value
		 */		
		override public function set width(value:Number):void {
			// round values to the nearest 0.05 to mimic DisplayObject's rounding for dimensions
			_width = Math.round(value * 20) * 0.05;
			
			// reset the scale to 1/1
			_scaleX = _scaleY = 1.0;
			
			resize();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function get height():Number {
			return _height;
		}
		
		/**
		 * @private
		 */		
		override public function set height(value:Number):void {
			// round values to the nearest 0.05 to mimic DisplayObject's rounding for dimensions
			_height = Math.round(value * 20) * 0.05;
			
			// reset the scale to 1/1
			_scaleX = _scaleY = 1.0;
			
			resize();
		}
		
		/**
		 * @inerhitDoc
		 */		
		override public function get scaleX():Number {
			return _scaleX;
		}
		
		/**
		 * @private
		 */		
		override public function set scaleX(value:Number):void {
			_scaleX = value;
			
			resize();
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function get scaleY():Number {
			return _scaleY;
		}
		
		/**
		 * @private
		 */		
		override public function set scaleY(value:Number):void {
			_scaleY = value;
			
			resize();
		}
		
		/**
		 * Sets both the scaleX and scaleY properties of the Scale9Bitmap.
		 * @return 
		 */		
		public function get scale():Number {
			return (_scaleX == _scaleY) ? _scaleX : NaN;
		}
		
		/**
		 * @private
		 * @param value
		 */		
		public function set scale(value:Number):void {
			_scaleX = _scaleY = value;
			
			resize();
		}
		
		/**
		 * Indicates if the BitmapData and scale9Grid Rectangle are set and if the scale9Grid Rectangle is within bounds of the BitmapData.
		 * @private
		 * @return 
		 */		
		protected function get valid():Boolean {
			return _bitmapData && _scale9Grid && _scale9Grid.right <= _bitmapData.width && _scale9Grid.bottom <= _bitmapData.height;
		}
		
		/**
		 * Sets both the BitmapData and scale9Grid with one method.
		 * @param bitmapData
		 * @param scale9Grid
		 * @throws ArgumentError Throws if bitmapData or scale9Grid is null, or if scale9Grid is outside the bounds of bitmapData.
		 */		
		public function setup(bitmapData:BitmapData, scale9Grid:Rectangle):void {
			// clear the BitmapData from memory
			if (_bitmapData) _bitmapData.dispose();
			
			_bitmapData = bitmapData;
			_scale9Grid = scale9Grid;
			
			if (!valid) {
				throw new ArgumentError("Invalid parameters. One or both are either null or the scale9Grid is larger than the bitmapData");
			}
			
			update();
			resize();
		}
		
		/**
		 * Sets both the width and height of the Scale9Bitmap.
		 * @param width
		 * @param height
		 */		
		public function setSize(width:Number, height:Number):void {
			// round values to the nearest 0.05 to mimic DisplayObject's rounding for dimensions
			_width = Math.round(width * 20) * 0.05;
			_height = Math.round(height * 20) * 0.05;
			
			resize();
		}
		
		/**
		 * The Rectangle of the scalable portion of the Bitmap.
		 * @return 
		 */		
		override public function get scale9Grid():Rectangle {
			return _scale9Grid;
		}
		
		/**
		 * @private
		 * @param value
		 */		
		override public function set scale9Grid(value:Rectangle):void {
			_scale9Grid = value;
			
			update();
			resize();
		}
		
		/**
		 * The BitmapData to scale.
		 * @return 
		 */		
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		
		/**
		 * @private
		 * @param bitmapData
		 */		
		public function set bitmapData(bitmapData:BitmapData):void {
			// clear the BitmapData from memory
			if (_bitmapData) _bitmapData.dispose();
			
			_bitmapData = bitmapData;
			
			update();
			resize();
		}
		
		/**
		 * Splits the BitmapData into nine Bitmap cells.
		 * @private 
		 */		
		protected function update():void {
			if (!valid) return;
			
			var bitmap:Bitmap;
			var rect:Rectangle;

			// left cells' x
			rects[0].x =
			rects[3].x = 
			rects[6].x = 0;
			
			// center cells' x
			rects[1].x = 
			rects[4].x = 
			rects[7].x = _scale9Grid.x;
			
			// right cells' x
			rects[2].x = 
			rects[5].x = 
			rects[8].x = _scale9Grid.right; 
			
			// top cells' y
			rects[0].y = 
			rects[1].y =
			rects[2].y = 0;
			
			// middle cells' y
			rects[3].y = 
			rects[4].y = 
			rects[5].y = _scale9Grid.y;
			
			// bottom cells' y
			rects[6].y = 
			rects[7].y = 
			rects[8].y = _scale9Grid.bottom;
			
			// left cells' width
			rects[0].width = 
			rects[3].width = 
			rects[6].width = _scale9Grid.x; 
			
			// center cells' width
			rects[1].width = 
			rects[4].width = 
			rects[7].width = _scale9Grid.width; 
			
			// right cells' width
			rects[2].width = 
			rects[5].width = 
			rects[8].width = _bitmapData.width - _scale9Grid.right; 
			
			// top cells' height
			rects[0].height = 
			rects[1].height =
			rects[2].height = _scale9Grid.y;
			
			// middle cells' height
			rects[3].height = 
			rects[4].height = 
			rects[5].height = _scale9Grid.height;
			
			// bottom cells' height
			rects[6].height = 
			rects[7].height = 
			rects[8].height = _bitmapData.height - _scale9Grid.bottom;
			
			var m:uint = 9;
			
			for (var i:uint = 0; i < m; ++i) {
				bitmap = bitmaps[i];
				rect = rects[i];
				
				// clear the BitmapData from memory
				if (bitmap.bitmapData) bitmap.bitmapData.dispose();
				
				bitmap.bitmapData = new BitmapData(rect.width, rect.height);
				
				bitmap.bitmapData.copyPixels(_bitmapData, rect, point);
			}
		}
		
		/**
		 * Resizes the nine Bitmap cells to the scaled dimensions.
		 * @private
		 */		
		protected function resize():void {
			if (!valid) return;
			
			// calculate the scaled dimensions
			// round them so the cells don't have decimal spaces between them
			scaledWidth = Math.round(_width * _scaleX);
			scaledHeight = Math.round(_height * _scaleY);
			
			// left cells' x
			bitmaps[0].x =
			bitmaps[3].x = 
			bitmaps[6].x = 0;
			
			// center cells' x
			bitmaps[1].x = 
			bitmaps[4].x = 
			bitmaps[7].x = _scale9Grid.x;
			
			// right cells' x
			bitmaps[2].x = 
			bitmaps[5].x = 
			bitmaps[8].x = scaledWidth - (_bitmapData.width - _scale9Grid.right); 
			
			// top cells' y
			bitmaps[0].y = 
			bitmaps[1].y =
			bitmaps[2].y = 0;
			
			// middle cells' y
			bitmaps[3].y = 
			bitmaps[4].y = 
			bitmaps[5].y = _scale9Grid.y;
			
			// bottom cells' y
			bitmaps[6].y = 
			bitmaps[7].y = 
			bitmaps[8].y = scaledHeight - (_bitmapData.height - _scale9Grid.bottom);
			
			// left cells' width
			bitmaps[0].width = 
			bitmaps[3].width = 
			bitmaps[6].width = _scale9Grid.x; 
			
			// center cells' width
			bitmaps[1].width = 
			bitmaps[4].width = 
			bitmaps[7].width = scaledWidth - (_scale9Grid.x + _bitmapData.width - _scale9Grid.right); 
			
			// right cells' width
			bitmaps[2].width = 
			bitmaps[5].width = 
			bitmaps[8].width = _bitmapData.width - _scale9Grid.right; 
			
			// top cells' height
			bitmaps[0].height = 
			bitmaps[1].height =
			bitmaps[2].height = _scale9Grid.y;
			
			// middle cells' height
			bitmaps[3].height = 
			bitmaps[4].height = 
			bitmaps[5].height = scaledHeight - (_scale9Grid.y + _bitmapData.height - _scale9Grid.bottom);
			
			// bottom cells' height
			bitmaps[6].height = 
			bitmaps[7].height = 
			bitmaps[8].height = _bitmapData.height - _scale9Grid.bottom;
		}
	}
}