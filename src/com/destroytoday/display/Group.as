package com.destroytoday.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;

	/**
	 * The Group class handles horizontal and vertical layouts.
	 * @author Jonnie Hallman
	 */	
	public class Group extends SpritePlus {
		/**
		 * @private 
		 */
		protected var _arrange:String = GroupArrangeType.NONE;
		
		/**
		 * @private 
		 */		
		protected var _align:String = GroupAlignType.NONE;

		/**
		 * @private 
		 */
		protected var _gap:Number = 0.0;

		/**
		 * @private 
		 */
		protected var _childWidth:Number;

		/**
		 * @private 
		 */
		protected var _childHeight:Number;

		/**
		 * @private 
		 */
		protected var _childrenOffset:int;
		
		/**
		 * @private 
		 */
		protected var _excludeInvisible:Boolean;
		
		/**
		 * @private 
		 */
		protected var _paddingLeft:Number = 0.0;
		
		/**
		 * @private 
		 */
		protected var _paddingRight:Number = 0.0;
		
		/**
		 * @private 
		 */
		protected var _paddingTop:Number = 0.0;
		
		/**
		 * @private 
		 */
		protected var _paddingBottom:Number = 0.0;

		/**
		 * Constructs the Group instance.
		 */		
		public function Group() {
		}
		
		/**
		 * The alignment type of the Group's children.
		 * @return 
		 */		
		public function get align():String {
			return _align;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set align(value:String):void {
			if (value == _align) return;
			
			_align = value;
			
			updateChildren();
		}

		/**
		 * The arrangement of the Group's children. 
		 * @return 
		 */		
		public function get arrange():String {
			return _arrange;
		}

		/**
		 * @private 
		 * @param value
		 */		
		public function set arrange(value:String):void {
			if (value == _arrange) return;

			_arrange = value;
			
			if (_arrange == GroupArrangeType.HORIZONTAL_JUSTIFY || _arrange == GroupArrangeType.VERTICAL_JUSTIFY) {
				measureChildren = false;
			}

			updateChildren();
		}
		
		/**
		 * The inner left padding of the Group, affecting only the children.
		 * @return 
		 */		
		public function get paddingLeft():Number {
			return _paddingLeft;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set paddingLeft(value:Number):void {
			_paddingLeft = value;
			
			updateChildren();
		}
		
		/**
		 * The inner right padding of the Group, affecting only the children.
		 * @return 
		 */	
		public function get paddingRight():Number {
			return _paddingRight;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set paddingRight(value:Number):void {
			_paddingRight = value;
			
			updateChildren();
		}
		
		/**
		 * The inner top padding of the Group, affecting only the children.
		 * @return 
		 */	
		public function get paddingTop():Number {
			return _paddingTop;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set paddingTop(value:Number):void {
			_paddingTop = value;
			
			updateChildren();
		}
		
		/**
		 * The inner bottom padding of the Group, affecting only the children.
		 * @return 
		 */			
		public function get paddingBottom():Number {
			return _paddingBottom;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set paddingBottom(value:Number):void {
			_paddingBottom = value;
			
			updateChildren();
		}

		/**
		 * The gap between children. 
		 * @return 
		 */		
		public function get gap():Number {
			return _gap;
		}

		/**
		 * @private 
		 * @param value
		 */		
		public function set gap(value:Number):void {
			if (value == _gap) return;

			_gap = value;

			updateChildren();
		}
		
		/**
		 * Specifies whether children with visible set to false are excluded from the Group's layout settings.
		 * @return 
		 */		
		public function get excludeInvisible():Boolean {
			return _excludeInvisible;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set excludeInvisible(value:Boolean):void {
			if (value == _excludeInvisible) return;
			
			_excludeInvisible = value;
			
			updateChildren();
		}

		/**
		 * The width of each child when arrange is set to horizontal justify. 
		 * @return 
		 */		
		public function get childWidth():Number {
			return _childWidth;
		}

		/**
		 * The width of each child when arrange is set to vertical justify.
		 * @return 
		 */		
		public function get childHeight():Number {
			return _childHeight;
		}

		/**
		 * The number of children to offset the Group by, specifically used for virtual lists.
		 * @return 
		 */		
		public function get childrenOffset():int {
			return _childrenOffset;
		}

		/**
		 * @private 
		 * @param value
		 */		
		public function set childrenOffset(value:int):void {
			if (value == _childrenOffset) return;

			_childrenOffset = value;

			updateChildren();
		}
		
		/**
		 * A combined method to set the Group's layout, which provides better performance than setting arrange and align separately. 
		 * @param arrange the childrens' arrangement type
		 * @param align the childrens' alignment type
		 */		
		public function setLayout(arrange:String, align:String):void {
			if (arrange == _arrange && align == _align) return;
			
			_arrange = arrange;
			_align = align;
			
			if (_arrange == GroupArrangeType.HORIZONTAL_JUSTIFY || _arrange == GroupArrangeType.VERTICAL_JUSTIFY) {
				measureChildren = false;
			}
			
			updateChildren();
		}

		/**
		 * @inheritDoc
		 */		
		override public function updateChildren():void {
			var child:DisplayObject;
			var x:Number, y:Number;
			var i:uint, j:uint, n:uint;

			var m:uint = _children.length;

			if (_arrange == GroupArrangeType.LEFT_RIGHT) {
				x = _paddingLeft;
				_childWidth = NaN;
			} else if (_arrange == GroupArrangeType.RIGHT_LEFT) {
				x = -_paddingRight;
				_childWidth = NaN;
			} else if (_arrange == GroupArrangeType.HORIZONTAL_JUSTIFY) {
				x = _paddingLeft;
				n = m;
				
				if (_excludeInvisible) {
					for (i = 0; i < m; ++i) {
						child = children[i];
						
						if (!child.visible) --n;
					}
				}
				
				n += _childrenOffset;
				
				_childWidth = (this.width - (_paddingLeft + _paddingRight + (n - 1) * _gap)) / n;
			} else if (_arrange == GroupArrangeType.TOP_BOTTOM) {
				y = _paddingTop;
				_childHeight = NaN;
			} else if (_arrange == GroupArrangeType.BOTTOM_TOP) {
				y = -_paddingBottom;
				_childHeight = NaN;
			} else if (_arrange == GroupArrangeType.VERTICAL_JUSTIFY) {
				y = _paddingTop;
				n = m;
				
				if (_excludeInvisible) {
					for (i = 0; i < m; ++i) {
						child = children[i];
						
						if (!child.visible) --n;
					}
				}
				
				n += _childrenOffset;
				
				_childHeight = (this.height - (_paddingTop + _paddingBottom + (n - 1) * _gap)) / n;
			}

			for (i = 0; i < m; ++i) {
				child = _children[i];
				
				if (_excludeInvisible && !child.visible) continue;
				
				if (_arrange == GroupArrangeType.LEFT_RIGHT) {
					if (child is SpritePlus) x += (child as SpritePlus).marginLeft;
					
					child.x = x;
					
					if (_align == GroupAlignType.TOP) {
						child.y = 0.0;
					} else if (_align == GroupAlignType.MIDDLE) {
						child.y = -child.height / 2;
					} else if (_align == GroupAlignType.BOTTOM) {
						child.y = -child.height;
					}
					
					x += child.width + _gap;
					if (child is SpritePlus) x += (child as SpritePlus).marginRight;
				} else if (_arrange == GroupArrangeType.RIGHT_LEFT) {
					x -= child.width;
					if (child is SpritePlus) x -= (child as SpritePlus).marginRight;

					child.x = x;
					
					if (_align == GroupAlignType.TOP) {
						child.y = 0.0;
					} else if (_align == GroupAlignType.MIDDLE) {
						child.y = -child.height / 2;
					} else if (_align == GroupAlignType.BOTTOM) {
						child.y = -child.height;
					}

					x -= _gap;
					if (child is SpritePlus) x -= (child as SpritePlus).marginLeft;
				} else if (_arrange == GroupArrangeType.HORIZONTAL_JUSTIFY) {
					if (j > 0) x += _childWidth + _gap;

					child.x = x;
					child.width = _childWidth;
					
					if (_align == GroupAlignType.TOP) {
						child.y = 0.0;
					} else if (_align == GroupAlignType.MIDDLE) {
						child.y = -child.height / 2;
					} else if (_align == GroupAlignType.BOTTOM) {
						child.y = -child.height;
					}
				} else if (_arrange == GroupArrangeType.TOP_BOTTOM) {
					if (child is SpritePlus) y += (child as SpritePlus).marginTop;
					
					if (_align == GroupAlignType.LEFT) {
						child.x = 0.0;
					} else if (_align == GroupAlignType.CENTER) {
						child.x = -child.width / 2;
					} else if (_align == GroupAlignType.RIGHT) {
						child.x = -child.width;
					}
					
					child.y = y;

					y += child.height + _gap;
					if (child is SpritePlus) y += (child as SpritePlus).marginBottom;
				} else if (_arrange == GroupArrangeType.BOTTOM_TOP) {
					y -= child.height;
					if (child is SpritePlus) y -= (child as SpritePlus).marginBottom;

					if (_align == GroupAlignType.LEFT) {
						child.x = 0.0;
					} else if (_align == GroupAlignType.CENTER) {
						child.x = -child.width / 2;
					} else if (_align == GroupAlignType.RIGHT) {
						child.x = -child.width;
					}
					
					child.y = y;

					y -= _gap;
					if (child is SpritePlus) y -= (child as SpritePlus).marginTop;
				} else if (_arrange == GroupArrangeType.VERTICAL_JUSTIFY) {
					if (j > 0) y += _childHeight + _gap;
					
					if (_align == GroupAlignType.LEFT) {
						child.x = 0.0;
					} else if (_align == GroupAlignType.CENTER) {
						child.x = -child.width / 2;
					} else if (_align == GroupAlignType.RIGHT) {
						child.x = -child.width;
					}
					
					child.y = y;
					child.height = _childHeight;
				}
				
				++j;
			}
		}
	}
}