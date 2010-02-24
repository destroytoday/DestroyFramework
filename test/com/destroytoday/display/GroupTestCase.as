package com.destroytoday.display {
	import asunit.asserts.assertEquals;
	
	import flash.geom.Rectangle;

	public class GroupTestCase {
		public var group:Group;
		
		public function GroupTestCase() {
		}
		
		[Before]
		public function runBefore():void {
			var child:SpritePlus;
			
			group = new Group();
			
			var m:uint = 5;
			
			for (var i:uint = 0; i < m; ++i) {
				child = group.addChild(new SpritePlus()) as SpritePlus;
				
				child.graphics.beginFill(0xFF0099);
				child.graphics.drawRect(0.0, 0.0, 100.0, 100.0);
				child.graphics.endFill();
			}
		}
		
		[After]
		public function runAfter():void {
			group = null;
		}
		
		//
		// Helpers
		//
		
		protected function testChildrenBounds(...children:Array):void {
			var m:uint = group.numChildren;
			
			for (var i:uint = 0; i < m; ++i) {
				assertEquals((children[i] as Rectangle).x, (group.children[i] as SpritePlus).x);
				assertEquals((children[i] as Rectangle).y, (group.children[i] as SpritePlus).y);
				assertEquals((children[i] as Rectangle).width, (group.children[i] as SpritePlus).width);
				assertEquals((children[i] as Rectangle).height, (group.children[i] as SpritePlus).height);
			}
		}
		
		protected function setChildrenMargins(left:Number, top:Number, right:Number, bottom:Number):void {
			var child:SpritePlus;
			var m:uint = 5;
			
			for (var i:uint = 0; i < m; ++i) {
				child = group.children[i] as SpritePlus;
				
				child.marginLeft = left;
				child.marginTop = top;
				child.marginRight = right;
				child.marginBottom = bottom;
			}
		}
		
		//
		// Test
		//
		
		[Test]
		public function testLayoutLeftRight():void {
			group.arrange = GroupArrangeType.LEFT_RIGHT;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 100.0),
				new Rectangle(100.0, 0.0, 100.0, 100.0),
				new Rectangle(200.0, 0.0, 100.0, 100.0),
				new Rectangle(300.0, 0.0, 100.0, 100.0),
				new Rectangle(400.0, 0.0, 100.0, 100.0)
			);
			
			group.gap = 10.0;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 100.0),
				new Rectangle(110.0, 0.0, 100.0, 100.0),
				new Rectangle(220.0, 0.0, 100.0, 100.0),
				new Rectangle(330.0, 0.0, 100.0, 100.0),
				new Rectangle(440.0, 0.0, 100.0, 100.0)
			);
			
			group.paddingLeft = 20.0;
			
			testChildrenBounds(
				new Rectangle(20.0, 0.0, 100.0, 100.0),
				new Rectangle(130.0, 0.0, 100.0, 100.0),
				new Rectangle(240.0, 0.0, 100.0, 100.0),
				new Rectangle(350.0, 0.0, 100.0, 100.0),
				new Rectangle(460.0, 0.0, 100.0, 100.0)
			);
			
			setChildrenMargins(5.0, 0.0, 5.0, 0.0);
			group.updateChildren();
			
			testChildrenBounds(
				new Rectangle(25.0, 0.0, 100.0, 100.0),
				new Rectangle(145.0, 0.0, 100.0, 100.0),
				new Rectangle(265.0, 0.0, 100.0, 100.0),
				new Rectangle(385.0, 0.0, 100.0, 100.0),
				new Rectangle(505.0, 0.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.BOTTOM;
			
			testChildrenBounds(
				new Rectangle(25.0, -100.0, 100.0, 100.0),
				new Rectangle(145.0, -100.0, 100.0, 100.0),
				new Rectangle(265.0, -100.0, 100.0, 100.0),
				new Rectangle(385.0, -100.0, 100.0, 100.0),
				new Rectangle(505.0, -100.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.MIDDLE;
			
			testChildrenBounds(
				new Rectangle(25.0, -50.0, 100.0, 100.0),
				new Rectangle(145.0, -50.0, 100.0, 100.0),
				new Rectangle(265.0, -50.0, 100.0, 100.0),
				new Rectangle(385.0, -50.0, 100.0, 100.0),
				new Rectangle(505.0, -50.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.TOP;
			
			testChildrenBounds(
				new Rectangle(25.0, 0.0, 100.0, 100.0),
				new Rectangle(145.0, 0.0, 100.0, 100.0),
				new Rectangle(265.0, 0.0, 100.0, 100.0),
				new Rectangle(385.0, 0.0, 100.0, 100.0),
				new Rectangle(505.0, 0.0, 100.0, 100.0)
			);
		}
		
		[Test]
		public function testLayoutTopBottom():void {
			group.arrange = GroupArrangeType.TOP_BOTTOM;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 100.0),
				new Rectangle(0.0, 100.0, 100.0, 100.0),
				new Rectangle(0.0, 200.0, 100.0, 100.0),
				new Rectangle(0.0, 300.0, 100.0, 100.0),
				new Rectangle(0.0, 400.0, 100.0, 100.0)
			);
			
			group.gap = 10.0;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 100.0),
				new Rectangle(0.0, 110.0, 100.0, 100.0),
				new Rectangle(0.0, 220.0, 100.0, 100.0),
				new Rectangle(0.0, 330.0, 100.0, 100.0),
				new Rectangle(0.0, 440.0, 100.0, 100.0)
			);
			
			group.paddingTop = 20.0;
			
			testChildrenBounds(
				new Rectangle(0.0, 20.0, 100.0, 100.0),
				new Rectangle(0.0, 130.0, 100.0, 100.0),
				new Rectangle(0.0, 240.0, 100.0, 100.0),
				new Rectangle(0.0, 350.0, 100.0, 100.0),
				new Rectangle(0.0, 460.0, 100.0, 100.0)
			);
			
			setChildrenMargins(0.0, 5.0, 0.0, 5.0);
			group.updateChildren();
			
			testChildrenBounds(
				new Rectangle(0.0, 25.0, 100.0, 100.0),
				new Rectangle(0.0, 145.0, 100.0, 100.0),
				new Rectangle(0.0, 265.0, 100.0, 100.0),
				new Rectangle(0.0, 385.0, 100.0, 100.0),
				new Rectangle(0.0, 505.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.RIGHT;
			
			testChildrenBounds(
				new Rectangle(-100.0, 25.0, 100.0, 100.0),
				new Rectangle(-100.0, 145.0, 100.0, 100.0),
				new Rectangle(-100.0, 265.0, 100.0, 100.0),
				new Rectangle(-100.0, 385.0, 100.0, 100.0),
				new Rectangle(-100.0, 505.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.CENTER;
			
			testChildrenBounds(
				new Rectangle(-50.0, 25.0, 100.0, 100.0),
				new Rectangle(-50.0, 145.0, 100.0, 100.0),
				new Rectangle(-50.0, 265.0, 100.0, 100.0),
				new Rectangle(-50.0, 385.0, 100.0, 100.0),
				new Rectangle(-50.0, 505.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.LEFT;
			
			testChildrenBounds(
				new Rectangle(0.0, 25.0, 100.0, 100.0),
				new Rectangle(0.0, 145.0, 100.0, 100.0),
				new Rectangle(0.0, 265.0, 100.0, 100.0),
				new Rectangle(0.0, 385.0, 100.0, 100.0),
				new Rectangle(0.0, 505.0, 100.0, 100.0)
			);
		}
		
		[Test]
		public function testLayoutRightLeft():void {
			group.arrange = GroupArrangeType.RIGHT_LEFT;
			
			testChildrenBounds(
				new Rectangle(-100.0, 0.0, 100.0, 100.0),
				new Rectangle(-200.0, 0.0, 100.0, 100.0),
				new Rectangle(-300.0, 0.0, 100.0, 100.0),
				new Rectangle(-400.0, 0.0, 100.0, 100.0),
				new Rectangle(-500.0, 0.0, 100.0, 100.0)
			);
			
			group.gap = 10.0;
			
			testChildrenBounds(
				new Rectangle(-100.0, 0.0, 100.0, 100.0),
				new Rectangle(-210.0, 0.0, 100.0, 100.0),
				new Rectangle(-320.0, 0.0, 100.0, 100.0),
				new Rectangle(-430.0, 0.0, 100.0, 100.0),
				new Rectangle(-540.0, 0.0, 100.0, 100.0)
			);
			
			group.paddingRight = 20.0;
			
			testChildrenBounds(
				new Rectangle(-120.0, 0.0, 100.0, 100.0),
				new Rectangle(-230.0, 0.0, 100.0, 100.0),
				new Rectangle(-340.0, 0.0, 100.0, 100.0),
				new Rectangle(-450.0, 0.0, 100.0, 100.0),
				new Rectangle(-560.0, 0.0, 100.0, 100.0)
			);
			
			setChildrenMargins(5.0, 0.0, 5.0, 0.0);
			group.updateChildren();
			
			testChildrenBounds(
				new Rectangle(-125.0, 0.0, 100.0, 100.0),
				new Rectangle(-245.0, 0.0, 100.0, 100.0),
				new Rectangle(-365.0, 0.0, 100.0, 100.0),
				new Rectangle(-485.0, 0.0, 100.0, 100.0),
				new Rectangle(-605.0, 0.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.BOTTOM;
			
			testChildrenBounds(
				new Rectangle(-125.0, -100.0, 100.0, 100.0),
				new Rectangle(-245.0, -100.0, 100.0, 100.0),
				new Rectangle(-365.0, -100.0, 100.0, 100.0),
				new Rectangle(-485.0, -100.0, 100.0, 100.0),
				new Rectangle(-605.0, -100.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.MIDDLE;
			
			testChildrenBounds(
				new Rectangle(-125.0, -50.0, 100.0, 100.0),
				new Rectangle(-245.0, -50.0, 100.0, 100.0),
				new Rectangle(-365.0, -50.0, 100.0, 100.0),
				new Rectangle(-485.0, -50.0, 100.0, 100.0),
				new Rectangle(-605.0, -50.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.TOP;
			
			testChildrenBounds(
				new Rectangle(-125.0, 0.0, 100.0, 100.0),
				new Rectangle(-245.0, 0.0, 100.0, 100.0),
				new Rectangle(-365.0, 0.0, 100.0, 100.0),
				new Rectangle(-485.0, 0.0, 100.0, 100.0),
				new Rectangle(-605.0, 0.0, 100.0, 100.0)
			);
		}
		
		[Test]
		public function testLayoutBottomTop():void {
			group.arrange = GroupArrangeType.BOTTOM_TOP;
			
			testChildrenBounds(
				new Rectangle(0.0, -100.0, 100.0, 100.0),
				new Rectangle(0.0, -200.0, 100.0, 100.0),
				new Rectangle(0.0, -300.0, 100.0, 100.0),
				new Rectangle(0.0, -400.0, 100.0, 100.0),
				new Rectangle(0.0, -500.0, 100.0, 100.0)
			);
			
			group.gap = 10.0;
			
			testChildrenBounds(
				new Rectangle(0.0, -100.0, 100.0, 100.0),
				new Rectangle(0.0, -210.0, 100.0, 100.0),
				new Rectangle(0.0, -320.0, 100.0, 100.0),
				new Rectangle(0.0, -430.0, 100.0, 100.0),
				new Rectangle(0.0, -540.0, 100.0, 100.0)
			);
			
			group.paddingBottom = 20.0;
			
			testChildrenBounds(
				new Rectangle(0.0, -120.0, 100.0, 100.0),
				new Rectangle(0.0, -230.0, 100.0, 100.0),
				new Rectangle(0.0, -340.0, 100.0, 100.0),
				new Rectangle(0.0, -450.0, 100.0, 100.0),
				new Rectangle(0.0, -560.0, 100.0, 100.0)
			);
			
			setChildrenMargins(0.0, 5.0, 0.0, 5.0);
			group.updateChildren();
			
			testChildrenBounds(
				new Rectangle(0.0, -125.0, 100.0, 100.0),
				new Rectangle(0.0, -245.0, 100.0, 100.0),
				new Rectangle(0.0, -365.0, 100.0, 100.0),
				new Rectangle(0.0, -485.0, 100.0, 100.0),
				new Rectangle(0.0, -605.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.RIGHT;
			
			testChildrenBounds(
				new Rectangle(-100.0, -125.0, 100.0, 100.0),
				new Rectangle(-100.0, -245.0, 100.0, 100.0),
				new Rectangle(-100.0, -365.0, 100.0, 100.0),
				new Rectangle(-100.0, -485.0, 100.0, 100.0),
				new Rectangle(-100.0, -605.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.CENTER;
			
			testChildrenBounds(
				new Rectangle(-50.0, -125.0, 100.0, 100.0),
				new Rectangle(-50.0, -245.0, 100.0, 100.0),
				new Rectangle(-50.0, -365.0, 100.0, 100.0),
				new Rectangle(-50.0, -485.0, 100.0, 100.0),
				new Rectangle(-50.0, -605.0, 100.0, 100.0)
			);
			
			group.align = GroupAlignType.LEFT;
			
			testChildrenBounds(
				new Rectangle(0.0, -125.0, 100.0, 100.0),
				new Rectangle(0.0, -245.0, 100.0, 100.0),
				new Rectangle(0.0, -365.0, 100.0, 100.0),
				new Rectangle(0.0, -485.0, 100.0, 100.0),
				new Rectangle(0.0, -605.0, 100.0, 100.0)
			);
		}
		
		[Test]
		public function testAlignHorizontalJustify():void {
			group.arrange = GroupArrangeType.HORIZONTAL_JUSTIFY;
			group.width = 1000.0;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 200.0, 100.0),
				new Rectangle(200.0, 0.0, 200.0, 100.0),
				new Rectangle(400.0, 0.0, 200.0, 100.0),
				new Rectangle(600.0, 0.0, 200.0, 100.0),
				new Rectangle(800.0, 0.0, 200.0, 100.0)
			);
			
			group.gap = 10.0;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 192.0, 100.0),
				new Rectangle(202.0, 0.0, 192.0, 100.0),
				new Rectangle(404.0, 0.0, 192.0, 100.0),
				new Rectangle(606.0, 0.0, 192.0, 100.0),
				new Rectangle(808.0, 0.0, 192.0, 100.0)
			);
			
			group.paddingLeft = 20.0;
			group.paddingRight = 20.0;
			
			testChildrenBounds(
				new Rectangle(20.0, 0.0, 184.0, 100.0),
				new Rectangle(214.0, 0.0, 184.0, 100.0),
				new Rectangle(408.0, 0.0, 184.0, 100.0),
				new Rectangle(602.0, 0.0, 184.0, 100.0),
				new Rectangle(796.0, 0.0, 184.0, 100.0)
			);
			
			group.align = GroupAlignType.BOTTOM;
			
			testChildrenBounds(
				new Rectangle(20.0, -100.0, 184.0, 100.0),
				new Rectangle(214.0, -100.0, 184.0, 100.0),
				new Rectangle(408.0, -100.0, 184.0, 100.0),
				new Rectangle(602.0, -100.0, 184.0, 100.0),
				new Rectangle(796.0, -100.0, 184.0, 100.0)
			);
			
			group.align = GroupAlignType.MIDDLE;
			
			testChildrenBounds(
				new Rectangle(20.0, -50.0, 184.0, 100.0),
				new Rectangle(214.0, -50.0, 184.0, 100.0),
				new Rectangle(408.0, -50.0, 184.0, 100.0),
				new Rectangle(602.0, -50.0, 184.0, 100.0),
				new Rectangle(796.0, -50.0, 184.0, 100.0)
			);
			
			group.align = GroupAlignType.TOP;
			
			testChildrenBounds(
				new Rectangle(20.0, 0.0, 184.0, 100.0),
				new Rectangle(214.0, 0.0, 184.0, 100.0),
				new Rectangle(408.0, 0.0, 184.0, 100.0),
				new Rectangle(602.0, 0.0, 184.0, 100.0),
				new Rectangle(796.0, 0.0, 184.0, 100.0)
			);
		}
		
		[Test]
		public function testAlignVerticalJustify():void {
			group.arrange = GroupArrangeType.VERTICAL_JUSTIFY;
			group.height = 1000.0;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 200.0),
				new Rectangle(0.0, 200.0, 100.0, 200.0),
				new Rectangle(0.0, 400.0, 100.0, 200.0),
				new Rectangle(0.0, 600.0, 100.0, 200.0),
				new Rectangle(0.0, 800.0, 100.0, 200.0)
			);
			
			group.gap = 10.0;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 192.0),
				new Rectangle(0.0, 202.0, 100.0, 192.0),
				new Rectangle(0.0, 404.0, 100.0, 192.0),
				new Rectangle(0.0, 606.0, 100.0, 192.0),
				new Rectangle(0.0, 808.0, 100.0, 192.0)
			);
			
			group.paddingTop = 20.0;
			group.paddingBottom = 20.0;
			
			testChildrenBounds(
				new Rectangle(0.0, 20.0, 100.0, 184.0),
				new Rectangle(0.0, 214.0, 100.0, 184.0),
				new Rectangle(0.0, 408.0, 100.0, 184.0),
				new Rectangle(0.0, 602.0, 100.0, 184.0),
				new Rectangle(0.0, 796.0, 100.0, 184.0)
			);
			
			group.align = GroupAlignType.RIGHT;
			
			testChildrenBounds(
				new Rectangle(-100.0, 20.0, 100.0, 184.0),
				new Rectangle(-100.0, 214.0, 100.0, 184.0),
				new Rectangle(-100.0, 408.0, 100.0, 184.0),
				new Rectangle(-100.0, 602.0, 100.0, 184.0),
				new Rectangle(-100.0, 796.0, 100.0, 184.0)
			);
			
			group.align = GroupAlignType.CENTER;
			
			testChildrenBounds(
				new Rectangle(-50.0, 20.0, 100.0, 184.0),
				new Rectangle(-50.0, 214.0, 100.0, 184.0),
				new Rectangle(-50.0, 408.0, 100.0, 184.0),
				new Rectangle(-50.0, 602.0, 100.0, 184.0),
				new Rectangle(-50.0, 796.0, 100.0, 184.0)
			);
			
			group.align = GroupAlignType.LEFT;
			
			testChildrenBounds(
				new Rectangle(0.0, 20.0, 100.0, 184.0),
				new Rectangle(0.0, 214.0, 100.0, 184.0),
				new Rectangle(0.0, 408.0, 100.0, 184.0),
				new Rectangle(0.0, 602.0, 100.0, 184.0),
				new Rectangle(0.0, 796.0, 100.0, 184.0)
			);
		}
		
		[Test]
		public function testExcludeInvisible():void {
			(group.children[0] as SpritePlus).visible = false;
			
			group.arrange = GroupArrangeType.LEFT_RIGHT;
			group.excludeInvisible = true;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 100.0),
				new Rectangle(0.0, 0.0, 100.0, 100.0),
				new Rectangle(100.0, 0.0, 100.0, 100.0),
				new Rectangle(200.0, 0.0, 100.0, 100.0),
				new Rectangle(300.0, 0.0, 100.0, 100.0)
			);
			
			group.measureChildren = false;
			group.width = 1000.0;
			group.arrange = GroupArrangeType.HORIZONTAL_JUSTIFY;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 100.0),
				new Rectangle(0.0, 0.0, 250.0, 100.0),
				new Rectangle(250.0, 0.0, 250.0, 100.0),
				new Rectangle(500.0, 0.0, 250.0, 100.0),
				new Rectangle(750.0, 0.0, 250.0, 100.0)
			);
			
			group.height = 1000.0;
			group.arrange = GroupArrangeType.VERTICAL_JUSTIFY;
			
			testChildrenBounds(
				new Rectangle(0.0, 0.0, 100.0, 100.0),
				new Rectangle(0.0, 0.0, 250.0, 250.0),
				new Rectangle(250.0, 250.0, 250.0, 250.0),
				new Rectangle(500.0, 500.0, 250.0, 250.0),
				new Rectangle(750.0, 750.0, 250.0, 250.0)
			);
		}
		
		[Test]
		public function testHorizontalChildrenOffset():void {
			group.setLayout(GroupArrangeType.HORIZONTAL_JUSTIFY, GroupAlignType.TOP);
			group.width = 500.0;
			
			assertEquals(100.0, group.childWidth);

			group.childrenOffset = -2;

			assertEquals(500.0 / 3, group.childWidth);
			
			group.childrenOffset = 2;
			
			assertEquals(500 / 7, group.childWidth);
		}
		
		[Test]
		public function testVerticalChildrenOffset():void {
			group.setLayout(GroupArrangeType.VERTICAL_JUSTIFY, GroupAlignType.LEFT);
			group.height = 500.0;
			
			assertEquals(100.0, group.childHeight);
			
			group.childrenOffset = -2;
			
			assertEquals(500.0 / 3, group.childHeight);
			
			group.childrenOffset = 2;
			
			assertEquals(500 / 7, group.childHeight);
		}
	}
}