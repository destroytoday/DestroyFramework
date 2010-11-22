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
		
		function get result():*;
		function get error():*;
		function get progress():*;
		function get status():String;
		
		function dispatchResult(value:*):void;
		function dispatchError(value:*):void;
		function dispatchProgress(value:*):void;
		function addResultProcessor(processor:Function):IPromise;
		
		function cancel():void;
	}
}