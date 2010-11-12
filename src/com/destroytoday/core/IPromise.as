package com.destroytoday.core
{
	import com.destroytoday.async.Promise;

	public interface IPromise
	{
		function get result():Object;
		function get error():Object;
		function get progress():Object;
		function get status():String;
		
		function addResultListener(listener:Function):IPromise;
		function dispatchResult(value:Object):void;
		
		function addErrorListener(listener:Function):IPromise;
		function dispatchError(value:Object):void;
		
		function addProgressListener(listener:Function):IPromise;
		function dispatchProgress(value:Object):void;

		function addStatusListener(listener:Function):IPromise;
		
		function cancel():void;
	}
}