package com.destroytoday.desktop
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;

	/**
	 * KonamiCode is a class to easily listen for the Konami code (up, down, up, down, left, right, left right, b, a, enter)
	 * @author Jonnie Hallman
	 */	
	public class KonamiCode
	{
		//--------------------------------------------------------------------------
		//
		//  Signals
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Dispatched upon successful entry of the Konami code 
		 */		
		public const executed:Signal = new Signal();
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * The correct Konami code combination 
		 */		
		protected const correctKeyCombination:Array =
			[
				Keyboard.UP,
				Keyboard.DOWN,
				Keyboard.UP,
				Keyboard.DOWN,
				Keyboard.LEFT,
				Keyboard.RIGHT,
				Keyboard.LEFT,
				Keyboard.RIGHT,
				Keyboard.B,
				Keyboard.A,
				Keyboard.ENTER
			];
		
		/**
		 * @private
		 * The user-inputted key combination 
		 */		
		protected var currentKeyCombination:Array = [];
		
		/**
		 * @private
		 * The timer that controls the key-entry threshold 
		 */		
		protected var thresholdTimer:Timer = new Timer(1000.0, 1.0);
		
		/**
		 * @private 
		 */		
		protected var _enabled:Boolean = true;
		
		/**
		 * @private 
		 */		
		protected var _stage:Stage;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructs the KonamiCode class 
		 * @param stage the stage to listen for key entry
		 * @param threshold the time in milliseconds allowed for key-entry before resetting
		 * 
		 */		
		public function KonamiCode(stage:Stage = null, threshold:Number = 1000.0)
		{
			this.stage = stage;
			this.threshold = threshold;
			
			thresholdTimer.addEventListener(TimerEvent.TIMER_COMPLETE, thresholdTimerCompleteHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Specifies whether or not the Konami code is enabled 
		 * @return
		 */		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * @private
		 * @param value
		 */		
		public function set enabled(value:Boolean):void
		{
			if (value == _enabled) return;
					
			_enabled = value;
			
			if (_stage && _enabled)
			{
				_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			else if (_stage && !_enabled)
			{
				_stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
		}
		
		/**
		 * The stage to listen for key entry 
		 * @return 
		 */		
		public function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set stage(value:Stage):void
		{
			if (value == _stage) return;
					
			if (_stage)
			{
				_stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			
			_stage = value;
			
			if (_stage && _enabled)
			{
				_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
		}
		
		/**
		 * The time in milliseconds allowed for key-entry before resetting
		 * The minimum value is 100 milliseconds
		 * @return 
		 */		
		public function get threshold():Number
		{
			return thresholdTimer.delay;
		}
		
		/**
		 * @private 
		 * @param value
		 */		
		public function set threshold(value:Number):void
		{
			if (value == thresholdTimer.delay) return;
			
			thresholdTimer.delay = value < 100.0 ? 100.0 : value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Resets the key entry
		 */		
		public function reset():void
		{
			currentKeyCombination.length = 0;
			
			thresholdTimer.reset();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * @param event
		 */		
		protected function keyUpHandler(event:KeyboardEvent):void
		{
			// ignore any key presses that have modifiers
			if (event.ctrlKey || event.shiftKey || event.altKey) return;
			
			// if the key pressed is the next one in the combo
			if (event.keyCode == correctKeyCombination[currentKeyCombination.length])
			{
				// if it's the last key (previously confirmed as correct)
				if (currentKeyCombination.length == correctKeyCombination.length - 1)
				{
					executed.dispatch();
					reset();
				}
				// if it's not the last key in the combo, move forward and restart the timer
				else
				{
					currentKeyCombination[currentKeyCombination.length] = event.keyCode;

					thresholdTimer.reset();
					thresholdTimer.start();
				}
			}
			// wrong key pressed
			else
			{
				reset();
			}
		}
		
		/**
		 * @private
		 * @param event
		 */		
		protected function thresholdTimerCompleteHandler(event:TimerEvent):void
		{
			// too slow
			reset();
		}
	}
}