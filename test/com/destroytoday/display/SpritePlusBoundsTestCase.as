package com.destroytoday.display {
	import asunit.asserts.assertEquals;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	
	public class SpritePlusBoundsTestCase {
		public var sprite:Sprite;
		public var group:Group;
		public var window:NativeWindow;
		public var spritePlus:SpritePlus;
		
		public function SpritePlusBoundsTestCase() {
		}
		
		[Before]
		public function beforeRun():void {
			spritePlus = new SpritePlus();
			window = new NativeWindow(new NativeWindowInitOptions());
			sprite = window.stage.addChild(new Sprite()) as Sprite;
			group = window.stage.addChild(new Group()) as Group;
			
			sprite.graphics.beginFill(0xFF0099);
			sprite.graphics.drawRect(0.0, 0.0, 800.0, 600.0);
			sprite.graphics.endFill();
			
			group.measureChildren = false;
			spritePlus.measureChildren = false;
			
			spritePlus.width = 300.0;
			spritePlus.height = 200.0;
		}
		
		[After]
		public function afterRun():void {
			spritePlus = null;
			window = null;
			sprite = null;
			group = null;
		}
		
		//
		// Helpers
		//
		
		protected function testOnAllParents(regularBounds:BoundsVO, groupBounds:BoundsVO, resizedGroupBounds:BoundsVO, stageBounds:BoundsVO, resizedStageBounds:BoundsVO):void {
			sprite.addChild(spritePlus);
			
			testBounds(regularBounds);
			
			sprite.removeChild(spritePlus);
			
			group.width = 800.0;
			group.height = 600.0;
			
			group.addChild(spritePlus);
			
			testBounds(groupBounds);
			
			group.width = 1600.0;
			group.height = 1200.0;
			
			testBounds(resizedGroupBounds);
			
			group.removeChild(spritePlus);
			
			window.stage.stageWidth = 800.0;
			window.stage.stageHeight = 600.0;
			
			window.stage.addChild(spritePlus);
			
			testBounds(stageBounds);
			
			window.stage.stageWidth = 1600.0;
			window.stage.stageHeight = 1200.0;
			
			testBounds(resizedStageBounds);
		}
		
		protected function testBounds(bounds:BoundsVO):void {
			assertEquals(bounds.x, spritePlus.x);
			assertEquals(bounds.y, spritePlus.y);
			assertEquals(bounds.left, spritePlus.left);
			assertEquals(bounds.top, spritePlus.top);
			assertEquals(bounds.right, spritePlus.right);
			assertEquals(bounds.bottom, spritePlus.bottom);
			assertEquals(bounds.width, spritePlus.width);
			assertEquals(bounds.height, spritePlus.height);
			assertEquals(bounds.center, spritePlus.center);
			assertEquals(bounds.middle, spritePlus.middle);
		}
		
		//
		// Tests
		//
		
		//
		// Left
		//
		
		[Test]
		public function testLeftBoundsZero():void {
			spritePlus.left = 0.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 0.0, 300.0, 200.0, 0.0, NaN, NaN, NaN),
				new BoundsVO(0.0, 0.0, 300.0, 200.0, 0.0, NaN, NaN, NaN),
				new BoundsVO(0.0, 0.0, 300.0, 200.0, 0.0, NaN, NaN, NaN),
				new BoundsVO(0.0, 0.0, 300.0, 200.0, 0.0, NaN, NaN, NaN),
				new BoundsVO(0.0, 0.0, 300.0, 200.0, 0.0, NaN, NaN, NaN)
			);
		}
		
		[Test]
		public function testLeftBoundsPositive():void {
			spritePlus.left = 100.0;
			
			testOnAllParents(
				new BoundsVO(100.0, 0.0, 300.0, 200.0, 100.0, NaN, NaN, NaN),
				new BoundsVO(100.0, 0.0, 300.0, 200.0, 100.0, NaN, NaN, NaN),
				new BoundsVO(100.0, 0.0, 300.0, 200.0, 100.0, NaN, NaN, NaN),
				new BoundsVO(100.0, 0.0, 300.0, 200.0, 100.0, NaN, NaN, NaN),
				new BoundsVO(100.0, 0.0, 300.0, 200.0, 100.0, NaN, NaN, NaN)
			);
		}
		
		[Test]
		public function testLeftBoundsNegative():void {
			spritePlus.left = -100.0;
			
			testOnAllParents(
				new BoundsVO(-100.0, 0.0, 300.0, 200.0, -100.0, NaN, NaN, NaN),
				new BoundsVO(-100.0, 0.0, 300.0, 200.0, -100.0, NaN, NaN, NaN),
				new BoundsVO(-100.0, 0.0, 300.0, 200.0, -100.0, NaN, NaN, NaN),
				new BoundsVO(-100.0, 0.0, 300.0, 200.0, -100.0, NaN, NaN, NaN),
				new BoundsVO(-100.0, 0.0, 300.0, 200.0, -100.0, NaN, NaN, NaN)
			);
		}
		
		//
		// Top
		//
		
		[Test]
		public function testTopBoundsZero():void {
			spritePlus.top = 0.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 0.0, 300.0, 200.0, NaN, 0.0, NaN, NaN),
				new BoundsVO(0.0, 0.0, 300.0, 200.0, NaN, 0.0, NaN, NaN),
				new BoundsVO(0.0, 0.0, 300.0, 200.0, NaN, 0.0, NaN, NaN),
				new BoundsVO(0.0, 0.0, 300.0, 200.0, NaN, 0.0, NaN, NaN),
				new BoundsVO(0.0, 0.0, 300.0, 200.0, NaN, 0.0, NaN, NaN)
			);
		}
		
		[Test]
		public function testTopBoundsPositive():void {
			spritePlus.top = 100.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 100.0, 300.0, 200.0, NaN, 100.0, NaN, NaN),
				new BoundsVO(0.0, 100.0, 300.0, 200.0, NaN, 100.0, NaN, NaN),
				new BoundsVO(0.0, 100.0, 300.0, 200.0, NaN, 100.0, NaN, NaN),
				new BoundsVO(0.0, 100.0, 300.0, 200.0, NaN, 100.0, NaN, NaN),
				new BoundsVO(0.0, 100.0, 300.0, 200.0, NaN, 100.0, NaN, NaN)
			);
		}
		
		[Test]
		public function testTopBoundsNegative():void {
			spritePlus.top = -100.0;
			
			testOnAllParents(
				new BoundsVO(0.0, -100.0, 300.0, 200.0, NaN, -100.0, NaN, NaN),
				new BoundsVO(0.0, -100.0, 300.0, 200.0, NaN, -100.0, NaN, NaN),
				new BoundsVO(0.0, -100.0, 300.0, 200.0, NaN, -100.0, NaN, NaN),
				new BoundsVO(0.0, -100.0, 300.0, 200.0, NaN, -100.0, NaN, NaN),
				new BoundsVO(0.0, -100.0, 300.0, 200.0, NaN, -100.0, NaN, NaN)
			);
		}
		
		//
		// Right
		//
		
		[Test]
		public function testRightBoundsZero():void {
			spritePlus.right = 0.0;
			
			testOnAllParents(
				new BoundsVO(800.0 - 300.0, 0.0, 300.0, 200.0, NaN, NaN, 0.0, NaN),
				new BoundsVO(800.0 - 300.0, 0.0, 300.0, 200.0, NaN, NaN, 0.0, NaN),
				new BoundsVO(1600.0 - 300.0, 0.0, 300.0, 200.0, NaN, NaN, 0.0, NaN),
				new BoundsVO(800.0 - 300.0, 0.0, 300.0, 200.0, NaN, NaN, 0.0, NaN),
				new BoundsVO(1600.0 - 300.0, 0.0, 300.0, 200.0, NaN, NaN, 0.0, NaN)
			);
		}
		
		[Test]
		public function testRightBoundsPositive():void {
			spritePlus.right = 100.0;
			
			testOnAllParents(
				new BoundsVO(800.0 - (300.0 + 100.0), 0.0, 300.0, 200.0, NaN, NaN, 100.0, NaN),
				new BoundsVO(800.0 - (300.0 + 100.0), 0.0, 300.0, 200.0, NaN, NaN, 100.0, NaN),
				new BoundsVO(1600.0 - (300.0 + 100.0), 0.0, 300.0, 200.0, NaN, NaN, 100.0, NaN),
				new BoundsVO(800.0 - (300.0 + 100.0), 0.0, 300.0, 200.0, NaN, NaN, 100.0, NaN),
				new BoundsVO(1600.0 - (300.0 + 100.0), 0.0, 300.0, 200.0, NaN, NaN, 100.0, NaN)
			);
		}
		
		[Test]
		public function testRightBoundsNegative():void {
			spritePlus.right = -100.0;
			
			testOnAllParents(
				new BoundsVO(800.0 - (300.0 - 100.0), 0.0, 300.0, 200.0, NaN, NaN, -100.0, NaN),
				new BoundsVO(800.0 - (300.0 - 100.0), 0.0, 300.0, 200.0, NaN, NaN, -100.0, NaN),
				new BoundsVO(1600.0 - (300.0 - 100.0), 0.0, 300.0, 200.0, NaN, NaN, -100.0, NaN),
				new BoundsVO(800.0 - (300.0 - 100.0), 0.0, 300.0, 200.0, NaN, NaN, -100.0, NaN),
				new BoundsVO(1600.0 - (300.0 - 100.0), 0.0, 300.0, 200.0, NaN, NaN, -100.0, NaN)
			);
		}
		
		//
		// Bottom
		//
		
		[Test]
		public function testBottomBoundsZero():void {
			spritePlus.bottom = 0.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 600.0 - 200.0, 300.0, 200.0, NaN, NaN, NaN, 0.0),
				new BoundsVO(0.0, 600.0 - 200.0, 300.0, 200.0, NaN, NaN, NaN, 0.0),
				new BoundsVO(0.0, 1200.0 - 200.0, 300.0, 200.0, NaN, NaN, NaN, 0.0),
				new BoundsVO(0.0, 600.0 - 200.0, 300.0, 200.0, NaN, NaN, NaN, 0.0),
				new BoundsVO(0.0, 1200.0 - 200.0, 300.0, 200.0, NaN, NaN, NaN, 0.0)
			);
		}
		
		[Test]
		public function testBottomBoundsPositive():void {
			spritePlus.bottom = 100.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 600.0 - (200.0 + 100.0), 300.0, 200.0, NaN, NaN, NaN, 100.0),
				new BoundsVO(0.0, 600.0 - (200.0 + 100.0), 300.0, 200.0, NaN, NaN, NaN, 100.0),
				new BoundsVO(0.0, 1200.0 - (200.0 + 100.0), 300.0, 200.0, NaN, NaN, NaN, 100.0),
				new BoundsVO(0.0, 600.0 - (200.0 + 100.0), 300.0, 200.0, NaN, NaN, NaN, 100.0),
				new BoundsVO(0.0, 1200.0 - (200.0 + 100.0), 300.0, 200.0, NaN, NaN, NaN, 100.0)
			);
		}
		
		[Test]
		public function testBottomBoundsNegative():void {
			spritePlus.bottom = -100.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 600.0 - (200.0 - 100.0), 300.0, 200.0, NaN, NaN, NaN, -100.0),
				new BoundsVO(0.0, 600.0 - (200.0 - 100.0), 300.0, 200.0, NaN, NaN, NaN, -100.0),
				new BoundsVO(0.0, 1200.0 - (200.0 - 100.0), 300.0, 200.0, NaN, NaN, NaN, -100.0),
				new BoundsVO(0.0, 600.0 - (200.0 - 100.0), 300.0, 200.0, NaN, NaN, NaN, -100.0),
				new BoundsVO(0.0, 1200.0 - (200.0 - 100.0), 300.0, 200.0, NaN, NaN, NaN, -100.0)
			);
		}
		
		//
		// Center
		//
		
		[Test]
		public function testCenterBoundsZero():void {
			spritePlus.center = 0.0;
			
			testOnAllParents(
				new BoundsVO(250.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 0.0, NaN),
				new BoundsVO(250.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 0.0, NaN),
				new BoundsVO(650.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 0.0, NaN),
				new BoundsVO(250.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 0.0, NaN),
				new BoundsVO(650.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 0.0, NaN)
			);
		}
		
		[Test]
		public function testCenterBoundsPositive():void {
			spritePlus.center = 100.0;
			
			testOnAllParents(
				new BoundsVO(350.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 100.0, NaN),
				new BoundsVO(350.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 100.0, NaN),
				new BoundsVO(750.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 100.0, NaN),
				new BoundsVO(350.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 100.0, NaN),
				new BoundsVO(750.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, 100.0, NaN)
			);
		}
		
		[Test]
		public function testCenterBoundsNegative():void {
			spritePlus.center = -100.0;
			
			testOnAllParents(
				new BoundsVO(150.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, -100.0, NaN),
				new BoundsVO(150.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, -100.0, NaN),
				new BoundsVO(550.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, -100.0, NaN),
				new BoundsVO(150.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, -100.0, NaN),
				new BoundsVO(550.0, 0.0, 300.0, 200.0, NaN, NaN, NaN, NaN, -100.0, NaN)
			);
		}
		
		//
		// Middle
		//
		
		[Test]
		public function testMiddleBoundsZero():void {
			spritePlus.middle = 0.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 300.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 0.0),
				new BoundsVO(0.0, 300.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 0.0),
				new BoundsVO(0.0, 600.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 0.0),
				new BoundsVO(0.0, 300.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 0.0),
				new BoundsVO(0.0, 600.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 0.0)
			);
		}
		
		[Test]
		public function testMiddleBoundsPositive():void {
			spritePlus.middle = 100.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 300.0 - 100.0 + 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 100.0),
				new BoundsVO(0.0, 300.0 - 100.0 + 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 100.0),
				new BoundsVO(0.0, 600.0 - 100.0 + 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 100.0),
				new BoundsVO(0.0, 300.0 - 100.0 + 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 100.0),
				new BoundsVO(0.0, 600.0 - 100.0 + 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, 100.0)
			);
		}
		
		[Test]
		public function testMiddleBoundsNegative():void {
			spritePlus.middle = -100.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 300.0 - 100.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, -100.0),
				new BoundsVO(0.0, 300.0 - 100.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, -100.0),
				new BoundsVO(0.0, 600.0 - 100.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, -100.0),
				new BoundsVO(0.0, 300.0 - 100.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, -100.0),
				new BoundsVO(0.0, 600.0 - 100.0 - 100.0, 300.0, 200.0, NaN, NaN, NaN, NaN, NaN, -100.0)
			);
		}
		
		//
		// Left Right
		//
		
		[Test]
		public function testLeftRightBoundsZero():void {
			spritePlus.left = 0.0;
			spritePlus.right = 0.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 0.0, 800.0, 200.0, 0.0, NaN, 0.0, NaN),
				new BoundsVO(0.0, 0.0, 800.0, 200.0, 0.0, NaN, 0.0, NaN),
				new BoundsVO(0.0, 0.0, 1600.0, 200.0, 0.0, NaN, 0.0, NaN),
				new BoundsVO(0.0, 0.0, 800.0, 200.0, 0.0, NaN, 0.0, NaN),
				new BoundsVO(0.0, 0.0, 1600.0, 200.0, 0.0, NaN, 0.0, NaN)
			);
		}
		
		[Test]
		public function testLeftRightBoundsPositive():void {
			spritePlus.left = 100.0;
			spritePlus.right = 100.0;
			
			testOnAllParents(
				new BoundsVO(100.0, 0.0, 600.0, 200.0, 100.0, NaN, 100.0, NaN),
				new BoundsVO(100.0, 0.0, 600.0, 200.0, 100.0, NaN, 100.0, NaN),
				new BoundsVO(100.0, 0.0, 1400.0, 200.0, 100.0, NaN, 100.0, NaN),
				new BoundsVO(100.0, 0.0, 600.0, 200.0, 100.0, NaN, 100.0, NaN),
				new BoundsVO(100.0, 0.0, 1400.0, 200.0, 100.0, NaN, 100.0, NaN)
			);
		}
		
		[Test]
		public function testLeftRightBoundsNegative():void {
			spritePlus.left = -100.0;
			spritePlus.right = -100.0;
			
			testOnAllParents(
				new BoundsVO(-100.0, 0.0, 1000.0, 200.0, -100.0, NaN, -100.0, NaN),
				new BoundsVO(-100.0, 0.0, 1000.0, 200.0, -100.0, NaN, -100.0, NaN),
				new BoundsVO(-100.0, 0.0, 1800.0, 200.0, -100.0, NaN, -100.0, NaN),
				new BoundsVO(-100.0, 0.0, 1000.0, 200.0, -100.0, NaN, -100.0, NaN),
				new BoundsVO(-100.0, 0.0, 1800.0, 200.0, -100.0, NaN, -100.0, NaN)
			);
		}
		
		//
		// Top Bottom
		//
		
		[Test]
		public function testTopBottomBoundsZero():void {
			spritePlus.top = 0.0;
			spritePlus.bottom = 0.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 0.0, 300.0, 600.0, NaN, 0.0, NaN, 0.0),
				new BoundsVO(0.0, 0.0, 300.0, 600.0, NaN, 0.0, NaN, 0.0),
				new BoundsVO(0.0, 0.0, 300.0, 1200.0, NaN, 0.0, NaN, 0.0),
				new BoundsVO(0.0, 0.0, 300.0, 600.0, NaN, 0.0, NaN, 0.0),
				new BoundsVO(0.0, 0.0, 300.0, 1200.0, NaN, 0.0, NaN, 0.0)
			);
		}
		
		[Test]
		public function testTopBottomBoundsPositive():void {
			spritePlus.top = 100.0;
			spritePlus.bottom = 100.0;
			
			testOnAllParents(
				new BoundsVO(0.0, 100.0, 300.0, 400.0, NaN, 100.0, NaN, 100.0),
				new BoundsVO(0.0, 100.0, 300.0, 400.0, NaN, 100.0, NaN, 100.0),
				new BoundsVO(0.0, 100.0, 300.0, 1000.0, NaN, 100.0, NaN, 100.0),
				new BoundsVO(0.0, 100.0, 300.0, 400.0, NaN, 100.0, NaN, 100.0),
				new BoundsVO(0.0, 100.0, 300.0, 1000.0, NaN, 100.0, NaN, 100.0)
			);
		}
		
		[Test]
		public function testTopBottomBoundsNegative():void {
			spritePlus.top = -100.0;
			spritePlus.bottom = -100.0;
			
			testOnAllParents(
				new BoundsVO(0.0, -100.0, 300.0, 800.0, NaN, -100.0, NaN, -100.0),
				new BoundsVO(0.0, -100.0, 300.0, 800.0, NaN, -100.0, NaN, -100.0),
				new BoundsVO(0.0, -100.0, 300.0, 1400.0, NaN, -100.0, NaN, -100.0),
				new BoundsVO(0.0, -100.0, 300.0, 800.0, NaN, -100.0, NaN, -100.0),
				new BoundsVO(0.0, -100.0, 300.0, 1400.0, NaN, -100.0, NaN, -100.0)
			);
		}
	}
}



class BoundsVO {
	public var x:Number;
	public var y:Number;
	public var width:Number;
	public var height:Number;
	public var left:Number;
	public var top:Number;
	public var right:Number;
	public var bottom:Number;
	public var center:Number;
	public var middle:Number;
	
	public function BoundsVO(x:Number = NaN, y:Number = NaN, width:Number = NaN, height:Number = NaN, left:Number = NaN, top:Number = NaN, right:Number = NaN, bottom:Number = NaN, center:Number = NaN, middle:Number = NaN) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.left = left;
		this.top = top;
		this.right = right;
		this.bottom = bottom;
		this.center = center;
		this.middle = middle;
	}
}