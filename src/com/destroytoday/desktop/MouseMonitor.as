package com.destroytoday.desktop
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class MouseMonitor
	{
		//--------------------------------------------------------------------------
		//
		//  Instances
		//
		//--------------------------------------------------------------------------
		
		protected static const instance:MouseMonitor = new MouseMonitor();
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var stageList:Dictionary = new Dictionary(true);
		
		protected var _isDown:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MouseMonitor()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public static function get isDown():Boolean
		{
			return instance._isDown;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------
		// Public 
		//--------------------------------------
		
		public static function addStage(stage:Stage):Stage
		{
			if (instance.stageExists(stage)) return stage;

			instance.stageList[stage] = null;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, instance.stageMouseDownHandler, false, int.MAX_VALUE, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, instance.stageMouseUpHandler, false, int.MAX_VALUE, true);
			
			return stage;
		}
		
		public static function removeStage(stage:Stage):Stage
		{
			if (instance.stageExists(stage))
			{
				trace("stage removed!");
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, instance.stageMouseDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, instance.stageMouseUpHandler);
				
				delete instance.stageList[stage];
			}
			
			return stage;
		}
		
		//--------------------------------------
		// Protected 
		//--------------------------------------
		
		protected function stageExists(stage:Stage):Boolean
		{
			for (var _stage:Object in instance.stageList)
			{
				if (_stage == stage) return true;
			}
			
			return false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		protected function stageMouseDownHandler(event:MouseEvent):void
		{
			_isDown = true;
		}
		
		protected function stageMouseUpHandler(event:MouseEvent):void
		{
			_isDown = false;
		}
	}
}