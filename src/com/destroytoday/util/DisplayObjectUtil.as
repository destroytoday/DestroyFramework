package com.destroytoday.util {
	import flash.display.DisplayObject;
	
	/**
	 * The DisplayObjectUtil class is a collection of methods for managing DisplayObjects.
	 * @author Jonnie Hallman
	 */	
	public class DisplayObjectUtil {
		/**
		 * @private
		 */		
		public function DisplayObjectUtil() {
			throw new Error("The DisplayObjectUtil class cannot be instantiated.");
		}

		/**
		 * Brings the DisplayObject to the front of the display list. The <code>back</code> parameter can be used to pull the DisplayObject back a few levels from the front.
		 * @param object the DisplayObject to reorder
		 * @param back the number of levels from the front of the display list
		 * @return the new index of the DisplayObject
		 */		
		public static function bringToFront(object:DisplayObject, back:uint = 0):int {
			if (!object.parent) return -1;
			
			var index:int = object.parent.numChildren - (back + 1);
			index = NumberUtil.confine(index, 0, object.parent.numChildren - 1);
			
			object.parent.setChildIndex(object, index);
			
			return index;
		}
		
		/**
		 * Brings the DisplayObject forward in the display list. The <code>steps</code> parameter can be used to jump more than one level.
		 * @param object the DisplayObject to reorder
		 * @param steps the number of levels bring the DisplayObject forward
		 * @return the new index of the DisplayObject
		 */		
		public static function bringForward(object:DisplayObject, steps:uint = 1):int {
			if (!object.parent) return -1;
			
			var index:int = object.parent.getChildIndex(object) + steps;
			index = NumberUtil.confine(index, 0, object.parent.numChildren - 1);
			
			object.parent.setChildIndex(object, index);
			
			return index;
		}
		
		/**
		 * Sends the DisplayObject to the back of the display list. The <code>forward</code> parameter can be used to bring the DisplayObject forward a few levels from the back.
		 * @param object the DisplayObject to reorder
		 * @param forward the number of levels from the back of the display list
		 * @return the new index of the DisplayObject
		 */	
		public static function sendToBack(object:DisplayObject, forward:uint = 0):int {
			if (!object.parent) return -1;
			
			var index:int = NumberUtil.confine(forward, 0, object.parent.numChildren - 1);
			
			object.parent.setChildIndex(object, index);
			
			return index;
		}
		
		/**
		 * Sends the DisplayObject back in the display list. The <code>steps</code> parameter can be used to jump more than one level.
		 * @param object the DisplayObject to reorder
		 * @param steps the number of levels send the DisplayObject backward
		 * @return the new index of the DisplayObject
		 */		
		public static function sendBackward (object:DisplayObject, steps:uint = 1):int {
			if (!object.parent) return -1;
			
			var index:int = object.parent.getChildIndex(object) - steps;
			index = NumberUtil.confine(index, 0, object.parent.numChildren - 1);
			
			object.parent.setChildIndex(object, index);
			
			return index;
		}
	}
}