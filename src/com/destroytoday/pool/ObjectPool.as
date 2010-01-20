package com.destroytoday.pool {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * The ObjectPool class manages object instantiation and recycling.
	 * @author Jonnie Hallman
	 */

	public class ObjectPool {
		/**
		 * @private
		 */
		protected var _type:Class;

		/**
		 * @private
		 */
		protected var _limit:int = -1;

		/**
		 * The array that stores the idle weak objects.
		 */
		protected var weakObjects:Array;

		/**
		 * The array that stores the strong objects.
		 */
		protected var strongObjects:Array;

		/**
		 * Returns the objects' class. The class is set during instantiation of the pool. This is primarily used by the ObjectWaterpark class.
		 * @return
		 */
		public function get type():Class {
			return _type;
		}

		/**
		 * Returns the number of unused objects in the pool.
		 * @return
		 */
		public function get length():int {
			return weakObjects.length;
		}

		/**
		 * An optional function for instantiating objects in the pool to accommodate ones that require arguments in their constructors.
		 * The function <i>must</i> return the object that is instantiated.
		 * @default null
		 * @example The following code is an example of using <code>factoryFunction</code> to allow the Timer class be used in a pool:
		 * <listing version="3.0">
		 * var pool:ObjectPool = new ObjectPool(Timer);
		 *
		 * function _instantiator():Object {
		 * 	return new Timer(0);
		 * }
		 *
		 * pool.factoryFunction = _instantiator;
		 *
		 * var timer:Timer = pool.getObject() as Timer;
		 * </listing>
		 */
		public var instantiator:Function;

		/**
		 * @param type the class of the objects
		 */
		public function ObjectPool(type:Class) {
			_type = type;

			weakObjects = [];
			strongObjects = [];
		}

		/**
		 * Used to limit the pool to the set number of objects.
		 * @return
		 */
		public function get limit():int {
			return _limit;
		}

		/**
		 * @param value
		 * @example The following code is an example of using <code>limit</code> to confine the size of the pool:
		 * <listing version="3.0">
		 * var pool:ObjectPool = new ObjectPool(Sprite);
		 *
		 * pool.limit = 10;
		 *
		 * pool.preallocate(20);
		 * trace (pool.length); // 10
		 *
		 * // remove limit
		 * pool.limit = 0;
		 *
		 * // adds only 10 since there are already 10 objects in the pool
		 * pool.preallocate(20);
		 * trace (pool.length); // 20
		 * </listing>
		 */
		public function set limit(value:int):void {
			_limit = value;

			if (_limit != -1 && length > _limit) {
				weakObjects.length = _limit;
			}
		}

		/**
		 * Instantiates the set number of objects and places them in the pool. This can be used to speed up performance.
		 * @param value the number of objects to instantiate
		 * @example The following code is an example of using <code>preallocate</code> to fill the pool:
		 * <listing version="3.0">
		 * var pool:ObjectPool = new ObjectPool(Sprite);
		 *
		 * trace (pool.length); // 0
		 *
		 * pool.preallocate(20);
		 * trace (pool.length); // 20
		 * </listing>
		 */
		public function preallocate(value:uint):void {
			var m:int = value - length;

			if (_limit > 0)
				m = Math.min(_limit, m);

			for (var i:uint = 0; i < m; ++i) {
				setObject();
			}
		}

		/**
		 * Specifies whether the provided object exists in the pool
		 * @param object the object to check for existance in the pool
		 * @return
		 * @example The following code is an example of using <code>objectExists</code> to check if an object is in the pool:
		 * <listing version="3.0">
		 * var pool:ObjectPool = new ObjectPool(Sprite);
		 * var object:Sprite = pool.getObject() as Sprite;
		 *
		 * trace (pool.objectExists(object)); // false
		 *
		 * pool.disposeObject(object);
		 * trace (pool.objectExists(object)); // true
		 * </listing>
		 */
		public function objectExists(object:Object):Boolean {
			return weakObjectExists(object) || strongObjectExists(object);
		}

		/**
		 * Specifies whether the provided object exists in the pool as a weak object
		 * @param object the object to check for existance in the pool
		 * @return
		 */
		protected function weakObjectExists(object:Object):Boolean {
			return weakObjects.indexOf(object) != -1;
		}

		/**
		 * Specifies whether the provided object exists in the pool as a strong object
		 * @param object the object to check for existance in the pool
		 * @return
		 */
		protected function strongObjectExists(object:Object):Boolean {
			return strongObjects.indexOf(object) != -1;
		}

		/**
		 * Retrieves an object from the pool. If there are no idle objects available, a new one is instantiated.
		 * @param weak specifies whether the object is weak (completely removed with no references) or strong (referenced within the pool to prevent being garbage collected)
		 * @return the retrieved object
		 * @example The following code is an example of using <code>getObject</code> to retrieve an object from the pool:
		 * <listing version="3.0">
		 * var pool:ObjectPool = new ObjectPool(Sprite);
		 *
		 * // object no longer exists in the pool since it was retrieved as a weak object
		 * var weakObject:Sprite = pool.getObject() as Sprite;
		 *
		 * // object will be garbage collected
		 * weakObject = null;
		 *
		 * // object no longer exists in the pool, but is referenced by the pool to prevent garbage collection
		 * var strongObject:Sprite = pool.getObject(false) as Sprite;
		 *
		 * // object will not be garbage collected because of its strong reference in the pool
		 * strongObject = null;
		 *
		 * </listing>
		 */
		public function getObject(weak:Boolean = true):Object {
			var object:Object;

			if (weakObjects.length > 0) {
				object = weakObjects[weakObjects.length - 1];

				--weakObjects.length;
			} else {
				object = (instantiator != null) ? instantiator() : new type();
			}

			if (!weak && !strongObjectExists(object)) {
				strongObjects[strongObjects.length] = object;
			}

			return object;
		}

		/**
		 * Places the object back into the pool. If the object already exists in the pool or disposing it would exceed the pool's <code>limit</code>, the method silently fails.
		 * @param object the object to place back into the pool
		 * @throws TypeError
		 * if the object is a different class than the pool has specified
		 * @see #limit
		 * @example The following code is an example of using <code>disposeObject</code> to recycle an object into the pool:
		 * <listing version="3.0">
		 * var pool:ObjectPool = new ObjectPool(Sprite);
		 * var object:Sprite = pool.getObject() as Sprite;
		 *
		 * // do something
		 *
		 * pool.disposeObject(object);
		 * </listing>
		 */
		public function disposeObject(object:Object):void {
			if (getDefinitionByName(getQualifiedClassName(object)) != type) {
				throw new TypeError("Disposed object type mismatch. Expected " + type + ", got " + getDefinitionByName(getQualifiedClassName(object)));
			}

			if ("dispose" in object) {
				object.dispose();
			}
			
			setObject(object);
		}

		/**
		 * Clears the pool of both strong and weak objects.
		 * @example The following code is an example of using <code>empty</code> free all objects from the pool:
		 * <listing version="3.0">
		 * var pool:ObjectPool = new ObjectPool(Sprite);
		 *
		 * pool.preallocate(20);
		 * trace (pool.length); // 20
		 *
		 * // do something
		 *
		 * pool.empty();
		 * trace (pool.length); // 0
		 * </listing>
		 */
		public function empty():void {
			weakObjects.length = 0;
			strongObjects.length = 0;
		}

		/**
		 * @private
		 */
		protected function setObject(object:Object = null):void {

			if (object && weakObjectExists(object) || limit > 0 && length + 1 > limit)
				return;

			if (object) {
				var n:int = strongObjects.indexOf(object);

				if (n != -1) {
					strongObjects.splice(n, 1);
				}
			}

			weakObjects[weakObjects.length] = object ? object : ((instantiator != null) ? instantiator() : new type());
		}
	}
}