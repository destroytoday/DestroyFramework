package com.destroytoday.core
{
	import com.destroytoday.async.Promise;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	public interface IPromise
	{
		function get completed():ISignal;
		function get failed():ISignal;
		function get progressChanged():ISignal;
		function get statusChanged():ISignal;
		
		function get result():Object;
		function get error():Object;
		function get progress():Object;
		function get status():String;
		
		function dispatchResult(value:Object):void;
		function dispatchError(value:Object):void;
		function dispatchProgress(value:Object):void;
		
		function cancel():void;
	}
}