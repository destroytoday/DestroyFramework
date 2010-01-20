package com.destroytoday.pool {
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ObjectWaterpark {
		protected static var pools:Dictionary = new Dictionary();

		public static function getPool(type:Class):ObjectPool {
			var pool:ObjectPool = pools[type] as ObjectPool;

			if (!pool)
				pool = pools[type] = new ObjectPool(type);

			return pool;
		}

		public static function getObject(type:Class, weak:Boolean = true):Object {
			var pool:ObjectPool = getPool(type);

			return pool.getObject(weak);
		}

		public static function disposeObject(object:Object):void {
			var typeName:String = getQualifiedClassName(object);
			var type:Class = getDefinitionByName(typeName) as Class;
			var pool:ObjectPool = getPool(type);

			pool.disposeObject(object);
		}

		public static function emptyPools():void {
			for each (var pool:ObjectPool in pools) {
				pool.empty();
			}
		}

		public static function dropPools():void {
			for (var type:Object in pools) {
				delete pools[type];
			}
		}
	}
}