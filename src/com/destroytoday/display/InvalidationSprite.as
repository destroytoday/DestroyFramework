package com.destroytoday.display
{
	import com.destroytoday.layouts.IBasicLayoutElement;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class InvalidationSprite extends Sprite implements IBasicLayoutElement
	{
		protected var invalidateFlag:Boolean;
		
		protected var invalidatePropertiesFlag:Boolean;
		
		protected var invalidateSizeFlag:Boolean;
		
		protected var invalidateDisplayListFlag:Boolean;
		
		public function InvalidationSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		public function invalidate():void 
		{
		
			if (stage && !invalidateFlag) {
				invalidateFlag = true;
				
				stage.addEventListener(Event.RENDER, invalidateHandler);
				stage.addEventListener(Event.ENTER_FRAME, invalidateHandler);
				stage.invalidate();
			}

		}
		
		public function invalidateProperties():void 
		{
			invalidate();
			invalidatePropertiesFlag = true;
		}
		
		public function invalidateSize():void 
		{
			invalidate();
			
			invalidateSizeFlag = true;
		}
		
		public function invalidateDisplayList():void 
		{
			invalidate();
			
			invalidateDisplayListFlag = true;
		}
		
		public function validateProperties():void
		{
			if (invalidatePropertiesFlag) {
				commitProperties();
			}
		}
		
		public function validateSize():void
		{
			if (invalidateSizeFlag) {
				measure();
			}
		}
		
		public function validateDisplayList():void
		{
			if (invalidateDisplayListFlag) {
				updateDisplayList();
			}
		}
		
		public function validateNow():void
		{
			if (stage) stage.removeEventListener(Event.RENDER, invalidateHandler);
			removeEventListener(Event.ENTER_FRAME, invalidateHandler);

			if (invalidatePropertiesFlag) {
				commitProperties();
			}
			
			if (invalidateSizeFlag) {
				measure();
			}
			
			if (invalidateDisplayListFlag) {
				updateDisplayList();
			}
			
			invalidateFlag = false;
		}
		
		protected function commitProperties():void 
		{
			invalidatePropertiesFlag = false;
		}
		
		protected function measure():void
		{
			invalidateSizeFlag = false;
		}
		
		protected function updateDisplayList():void 
		{
			invalidateDisplayListFlag = false;
		}

		protected function addedToStageHandler(event:Event):void 
		{
			invalidateSize();
			invalidateDisplayList();
		}
		
		protected function removedFromStageHandler(event:Event):void 
		{
			stage.removeEventListener(Event.RENDER, invalidateHandler);
			stage.removeEventListener(Event.ENTER_FRAME, invalidateHandler);
			invalidateFlag = false;
		}
		
		protected function invalidateHandler(event:Event):void 
		{
			validateNow();
		}
	}
}