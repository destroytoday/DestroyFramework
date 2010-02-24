package com.destroytoday.display {
	import asunit.asserts.assertEquals;
	
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	
	public class SpritePlusTestCase {
		public var sprite:SpritePlus;
		
		public function SpritePlusTestCase() {
		}
		
		[Before]
		public function runBefore():void {
			sprite = new SpritePlus();
		}
		
		[After]
		public function runAfter():void {
		}
		
		//
		// Helpers
		//
		
		
		//
		// Tests
		//
		
		[Test]
		public function testAddChild():void {
			sprite.addChild(new Sprite());

			assertEquals(1, sprite.children.length);
			assertEquals(1, sprite.numChildren);
		}
		
		[Test]
		public function testAddChildAt():void {
			var m:uint = 5;
			var child:Sprite;
			
			for (var i:uint = 0; i < m; ++i) {
				child = new Sprite();
				
				child.name = String(i);
				
				sprite.addChildAt(child, 0);
			}
			
			assertEquals(5, sprite.children.length);
			assertEquals(5, sprite.numChildren);
			assertEquals("4", sprite.getChildAt(0).name);
			assertEquals("3", sprite.getChildAt(1).name);
			assertEquals("2", sprite.getChildAt(2).name);
			assertEquals("1", sprite.getChildAt(3).name);
			assertEquals("0", sprite.getChildAt(4).name);
		}
		
		[Test]
		public function testRemoveChild():void {
			var child:Sprite = sprite.addChild(new Sprite()) as Sprite;
			
			sprite.removeChild(child);
			
			assertEquals(0, sprite.children.length);
			assertEquals(0, sprite.numChildren);
		}
		
		[Test]
		public function testRemoveChildAt():void {
			var m:uint = 5;
			var child:Sprite;
			
			for (var i:uint = 0; i < m; ++i) {
				child = new Sprite();
				
				child.name = String(i);
				
				sprite.addChild(child);
			}
			
			sprite.removeChildAt(1);
			sprite.removeChildAt(2);
			
			assertEquals(3, sprite.children.length);
			assertEquals(3, sprite.numChildren);
			assertEquals("0", sprite.getChildAt(0).name);
			assertEquals("2", sprite.getChildAt(1).name);
			assertEquals("4", sprite.getChildAt(2).name);
		}
		
		[Test]
		public function testSetChildIndex():void {
			var m:uint = 5;
			var child:Sprite;
			
			for (var i:uint = 0; i < m; ++i) {
				child = new Sprite();
				
				child.name = String(i);
				
				sprite.addChild(child);
			}
			
			sprite.setChildIndex(sprite.getChildAt(0), 1);
			sprite.setChildIndex(sprite.getChildAt(2), 4);
			
			assertEquals("1", sprite.getChildAt(0).name);
			assertEquals("0", sprite.getChildAt(1).name);
			assertEquals("3", sprite.getChildAt(2).name);
			assertEquals("4", sprite.getChildAt(3).name);
			assertEquals("2", sprite.getChildAt(4).name);
		}
		
		[Test]
		public function testMeasureChildrenTrueSize():void {
			sprite.graphics.beginFill(0xFF0099);
			sprite.graphics.drawRect(0.0, 0.0, 500.0, 400.0);
			sprite.graphics.endFill();
			
			assertEquals(500.0, sprite.width);
			assertEquals(400.0, sprite.height);
			
			sprite.width = 1000.0;
			sprite.height = 800.0;
			
			assertEquals(1000.0, sprite.width);
			assertEquals(800.0, sprite.height);
		}
		
		[Test]
		public function testMeasureChildrenFalseSize():void {
			sprite.measureChildren = false;
			
			assertEquals(0.0, sprite.width);
			assertEquals(0.0, sprite.height);
			
			sprite.graphics.beginFill(0xFF0099);
			sprite.graphics.drawRect(0.0, 0.0, 500.0, 400.0);
			sprite.graphics.endFill();
			
			assertEquals(0.0, sprite.width);
			assertEquals(0.0, sprite.height);
			
			sprite.width = 1000.0;
			sprite.height = 800.0;
			
			assertEquals(1000.0, sprite.width);
			assertEquals(800.0, sprite.height);
		}
	}
}
