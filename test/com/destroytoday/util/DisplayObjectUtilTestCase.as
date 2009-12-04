package com.destroytoday.util {
	import flash.display.Sprite;
	
	import org.flexunit.Assert;
	
	public class DisplayObjectUtilTestCase {
		public var spriteContainer:Sprite;
		public var sprite0:Sprite;
		public var sprite1:Sprite;
		public var sprite2:Sprite;
		public var sprite3:Sprite;
		public var sprite4:Sprite;
		
		public function DisplayObjectUtilTestCase() {
			spriteContainer = new Sprite();
			sprite0 = spriteContainer.addChild(new Sprite()) as Sprite;
			sprite1 = spriteContainer.addChild(new Sprite()) as Sprite;
			sprite2 = spriteContainer.addChild(new Sprite()) as Sprite;
			sprite3 = spriteContainer.addChild(new Sprite()) as Sprite;
			sprite4 = spriteContainer.addChild(new Sprite()) as Sprite;
		}
		
		[Before]
		public function setUp():void {
			spriteContainer.setChildIndex(sprite0, 0);
			spriteContainer.setChildIndex(sprite1, 1);
			spriteContainer.setChildIndex(sprite2, 2);
			spriteContainer.setChildIndex(sprite3, 3);
			spriteContainer.setChildIndex(sprite4, 4);
		}
		
		[After]
		public function tearDown():void {
			
		}
		
		[Test]
		public function testBringToFront():void {
			Assert.assertEquals(-1, DisplayObjectUtil.bringToFront(spriteContainer));
			
			Assert.assertEquals(4, DisplayObjectUtil.bringToFront(sprite0));
			Assert.assertEquals(0, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(2, spriteContainer.getChildIndex(sprite3));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite4));
		}
		[Test]
		public function testBringToFrontBack():void {
			Assert.assertEquals(-1, DisplayObjectUtil.bringToFront(spriteContainer, 2));
			
			Assert.assertEquals(2, DisplayObjectUtil.bringToFront(sprite0, 2));
			Assert.assertEquals(0, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite3));
			Assert.assertEquals(4, spriteContainer.getChildIndex(sprite4));
		}
		
		[Test]
		public function testBringForward():void {
			Assert.assertEquals(-1, DisplayObjectUtil.bringForward(spriteContainer));
			
			Assert.assertEquals(1, DisplayObjectUtil.bringForward(sprite0));
			Assert.assertEquals(0, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(2, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite3));
			Assert.assertEquals(4, spriteContainer.getChildIndex(sprite4));
		}
		[Test]
		public function testBringForwardSteps():void {
			Assert.assertEquals(-1, DisplayObjectUtil.bringForward(spriteContainer, 2));
			
			Assert.assertEquals(2, DisplayObjectUtil.bringForward(sprite0, 2));
			Assert.assertEquals(0, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite3));
			Assert.assertEquals(4, spriteContainer.getChildIndex(sprite4));
		}
		[Test]
		public function testBringForwardStepsExceedingMax():void {
			Assert.assertEquals(-1, DisplayObjectUtil.bringForward(spriteContainer, 5));
			
			Assert.assertEquals(4, DisplayObjectUtil.bringForward(sprite0, 5));
			Assert.assertEquals(0, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(2, spriteContainer.getChildIndex(sprite3));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite4));
		}
		
		[Test]
		public function testSendToBack():void {
			Assert.assertEquals(-1, DisplayObjectUtil.sendToBack(spriteContainer));
			
			Assert.assertEquals(0, DisplayObjectUtil.sendToBack(sprite4));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite0));
			Assert.assertEquals(2, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(4, spriteContainer.getChildIndex(sprite3));
		}
		[Test]
		public function testSendToBackForward():void {
			Assert.assertEquals(-1, DisplayObjectUtil.sendToBack(spriteContainer, 2));
			
			Assert.assertEquals(2, DisplayObjectUtil.sendToBack(sprite4, 2));
			Assert.assertEquals(0, spriteContainer.getChildIndex(sprite0));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(4, spriteContainer.getChildIndex(sprite3));
		}
		
		[Test]
		public function testSendBackward():void {
			Assert.assertEquals(-1, DisplayObjectUtil.sendBackward(spriteContainer));
			
			Assert.assertEquals(3, DisplayObjectUtil.sendBackward(sprite4));
			Assert.assertEquals(0, spriteContainer.getChildIndex(sprite0));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(2, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(4, spriteContainer.getChildIndex(sprite3));
		}
		[Test]
		public function testSendBackwardSteps():void {
			Assert.assertEquals(-1, DisplayObjectUtil.sendBackward(spriteContainer, 2));
			
			Assert.assertEquals(2, DisplayObjectUtil.sendBackward(sprite4, 2));
			Assert.assertEquals(0, spriteContainer.getChildIndex(sprite0));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(4, spriteContainer.getChildIndex(sprite3));
		}
		[Test]
		public function testSendBackwardStepsExceedingMin():void {
			Assert.assertEquals(-1, DisplayObjectUtil.sendBackward(spriteContainer, 5));
			
			Assert.assertEquals(0, DisplayObjectUtil.sendBackward(sprite4, 5));
			Assert.assertEquals(1, spriteContainer.getChildIndex(sprite0));
			Assert.assertEquals(2, spriteContainer.getChildIndex(sprite1));
			Assert.assertEquals(3, spriteContainer.getChildIndex(sprite2));
			Assert.assertEquals(4, spriteContainer.getChildIndex(sprite3));
		}
	}
}