package com.destroytoday.async
{
	import com.destroytoday.constant.PromiseState;
	import com.destroytoday.core.IDisposable;
	import com.destroytoday.core.IPromise;
	
	/**
	 * Based on Shaun Smith's event-based Promise class
	 * https://github.com/darscan/robotlegs-extensions-Oil/blob/master/src/org/robotlegs/oil/async/Promise.as
	 * @author Jonnie Hallman
	 */
	public class Promise implements IPromise, IDisposable
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		protected var _resultListenerList:Vector.<Function>;
		
		protected var _resultProcessorList:Vector.<Function>;
		
		protected var _errorListenerList:Vector.<Function>;

		protected var _progressListenerList:Vector.<Function>;

		protected var _statusListenerList:Vector.<Function>;
		
		protected var _status:String = PromiseState.PENDING;
		
		protected var _result:Object;
		
		protected var _error:Object;
		
		protected var _progress:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Promise()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public function get status():String
		{
			return _status;
		}
		
		protected function setStatus(value:String):void
		{
			if (value == _status) return;
			
			_status = value;
			
			dispatch(_statusListenerList);
		}
		
		public function get result():Object
		{
			return _result;
		}
		
		public function get error():Object
		{
			return _error;
		}
		
		public function get progress():Object
		{
			return _progress;
		}
		
		protected function get resultListenerList():Vector.<Function>
		{
			return _resultListenerList ||= new Vector.<Function>();
		}
		
		protected function get resultProcessorList():Vector.<Function>
		{
			return _resultProcessorList ||= new Vector.<Function>();
		}
		
		protected function get errorListenerList():Vector.<Function>
		{
			return _errorListenerList ||= new Vector.<Function>();
		}
		
		protected function get progressListenerList():Vector.<Function>
		{
			return _progressListenerList ||= new Vector.<Function>();
		}
		
		protected function get statusListenerList():Vector.<Function>
		{
			return _statusListenerList ||= new Vector.<Function>();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addResultListener(listener:Function):IPromise
		{
			if (_status == PromiseState.COMPLETE)
			{
				listener(this);
			}
			else if (_status == PromiseState.PENDING)
			{
				resultListenerList[resultListenerList.length] = listener;
			}
			
			return this;
		}
		
		public function addResultProcessor(processor:Function):IPromise
		{
			if (_status == PromiseState.PENDING)
				resultProcessorList[resultProcessorList.length] = processor;
			
			return this;
		}
		
		public function addErrorListener(listener:Function):IPromise
		{
			if (_status == PromiseState.FAILED)
			{
				listener(this);
			}
			else if (_status == PromiseState.PENDING)
			{
				errorListenerList[errorListenerList.length] = listener;
			}
			
			return this;
		}
		
		public function addStatusListener(listener:Function):IPromise
		{
			statusListenerList[statusListenerList.length] = listener;
			
			return this;
		}
		
		public function addProgressListener(listener:Function):IPromise
		{
			if (_status == PromiseState.FAILED || _status == PromiseState.COMPLETE || _status == PromiseState.CANCELLED)
			{
				listener(this);
			}
			else if (_status == PromiseState.PENDING)
			{
				progressListenerList[progressListenerList.length] = listener;
			}
			
			return this;
		}
		
		public function dispatchResult(value:Object):void
		{
			value = processResult(value);
			_result = value;
			
			setStatus(PromiseState.COMPLETE);
			dispatch(_resultListenerList);
			resetListeners();
		}
		
		public function dispatchError(value:Object):void
		{
			_error = value;
			
			setStatus(PromiseState.FAILED);
			dispatch(_errorListenerList);
			resetListeners();
		}
		
		public function dispatchProgress(value:Object):void
		{
			_progress = value;
			
			dispatch(_progressListenerList);
		}
		
		public function cancel():void
		{
			setStatus(PromiseState.CANCELLED);
			resetListeners();
		}
		
		public function dispose():void
		{
			_status = PromiseState.PENDING;
			_result = null;
			_error = null;
			_progress = null;
			
			resetListeners();
		}
		
		protected function resetListeners():void
		{
			if (_resultListenerList)
				_resultListenerList.length = 0;
			if (_resultProcessorList)
				_resultProcessorList.length = 0;
			if (_errorListenerList)
				_errorListenerList.length = 0;
			if (_progressListenerList)
				_progressListenerList.length = 0;
			if (_statusListenerList)
				_statusListenerList.length = 0;
		}
		
		protected function dispatch(listenerList:Vector.<Function>):void
		{
			if (!listenerList)
				return;
			
			for each (var listener:Function in listenerList)
			{
				listener(this);
			}
		}
		
		protected function processResult(result:Object):Object
		{
			if (_resultProcessorList)
			{
				for each (var processor:Function in resultProcessorList)
				{
					result = processor(result);
				}
			}
			
			return result;
		}
		
	}
}