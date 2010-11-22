package com.destroytoday.async
{
	import com.destroytoday.constant.PromiseState;
	import com.destroytoday.core.IDisposable;
	import com.destroytoday.core.IPromise;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	/**
	 * Based on Shaun Smith's Promise class
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
		
		protected var _completed:Signal;
		
		protected var _failed:Signal;
		
		protected var _progressChanged:Signal;
		
		protected var _statusChanged:Signal;
		
		protected var _resultProcessorList:Vector.<Function>;
		
		protected var _status:String = PromiseState.PENDING;
		
		protected var _result:*;
		
		protected var _error:*;
		
		protected var _progress:*;
		
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
		
		public function get completed():ISignal
		{
			return _completed ||= new Signal(IPromise);
		}
		
		public function get failed():ISignal
		{
			return _failed ||= new Signal(IPromise);
		}
		
		public function get progressChanged():ISignal
		{
			return _progressChanged ||= new Signal(IPromise);
		}
		
		public function get statusChanged():ISignal
		{
			return _statusChanged ||= new Signal(IPromise);
		}
		
		public function get status():String
		{
			return _status;
		}
		
		protected function setStatus(value:String):void
		{
			if (value == _status) return;
			
			_status = value;
			
			if (_statusChanged) _statusChanged.dispatch(this);
		}
		
		public function get result():*
		{
			return _result;
		}
		
		public function get error():*
		{
			return _error;
		}
		
		public function get progress():*
		{
			return _progress;
		}
		
		protected function get resultProcessorList():Vector.<Function>
		{
			return _resultProcessorList ||= new Vector.<Function>();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function addResultProcessor(processor:Function):IPromise
		{
			if (_status == PromiseState.PENDING)
				resultProcessorList[resultProcessorList.length] = processor;
			
			return this;
		}
		
		public function dispatchResult(value:*):void
		{
			value = processResult(value);
			_result = value;
			
			setStatus(PromiseState.COMPLETE);
			
			if (_completed) _completed.dispatch(this);
			
			removeAllListeners();
		}
		
		public function dispatchError(value:*):void
		{
			_error = value;
			
			setStatus(PromiseState.FAILED);
			
			if (_failed) _failed.dispatch(this);
			
			removeAllListeners();
		}
		
		public function dispatchProgress(value:*):void
		{
			_progress = value;
			
			if (_progressChanged) _progressChanged.dispatch(this);
		}
		
		public function cancel():void
		{
			setStatus(PromiseState.CANCELLED);
			removeAllListeners();
		}
		
		public function dispose():void
		{
			_status = PromiseState.PENDING;
			_result = null;
			_error = null;
			_progress = null;
			
			removeAllListeners();
		}
		
		protected function removeAllListeners():void
		{
			if (_completed)
				_completed.removeAll();
			if (_failed)
				_failed.removeAll();
			if (_progressChanged)
				_progressChanged.removeAll();
			if (_statusChanged)
				_statusChanged.removeAll();
			
			if (_resultProcessorList)
				_resultProcessorList.length = 0;
		}
		
		protected function processResult(result:*):*
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