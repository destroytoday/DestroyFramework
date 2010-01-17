package com.destroytoday.debug {
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Timer;

	/**
	 * The Console class provides developers with trace methods that write activity to a log file.
	 * @author Jonnie Hallman
	 */	
	public class Console {
		/**
		 * @private 
		 */		
		protected static const SUCCESS:String = "success";
		
		/**
		 * @private 
		 */		
		protected static const ERROR:String = "error";
		
		/**
		 * @private 
		 */		
		protected static const CANCEL:String = "cancel";
		
		/**
		 * @private 
		 */		
		protected static const PRINT:String = "print";
		
		/**
		 * @private 
		 */		
		protected static var file:File = new File();

		/**
		 * @private 
		 */		
		protected static var fileStream:FileStream = new FileStream();
		
		/**
		 * @private 
		 */		
		protected static var timer:Timer = new Timer(0, 1);
		
		/**
		 * @private 
		 */	
		protected static var buffer:String = "";
		
		/**
		 * @private 
		 */	
		protected static var inTransaction:Boolean;
		
		/**
		 * @private 
		 */		
		protected static var clearNextTransaction:Boolean;
		
		/**
		 * Specifies whether to trace success entries. 
		 */		
		public static var traceSuccess:Boolean;
		
		/**
		 * Specifies whether to trace error entries. 
		 */		
		public static var traceError:Boolean;
		
		/**
		 * Specifies whether to trace cancel entries. 
		 */	
		public static var traceCancel:Boolean;
		
		/**
		 * Specifies whether to trace print entries. 
		 * @default true
		 */	
		public static var tracePrint:Boolean = true;

		/**
		 * The Console class provides developers with methods to debug applications.
		 */		
		public function Console() {
			throw Error("The Console class cannot be instantiated.");
		}
		
		/**
		 * 
		 * @param path
		 * @param loaderInfo
		 * 
		 */		
		public static function init(path:String, loaderInfo:LoaderInfo):void {
			file.nativePath = path;

			fileStream.addEventListener(Event.CLOSE, writeCloseHandler);
			fileStream.addEventListener(IOErrorEvent.IO_ERROR, writeErrorHandler);
		
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, delayHandler);
			
			buffer = 
				"----------------------------------------------------------------------\n" +
				"[" + new Date() + "] Session Start\n" +
				"----------------------------------------------------------------------\n";
			
			commit();
		}

		/**
		 * The path to the log file.
		 * @return 
		 */		
		public static function get path():String {
			return file.nativePath;
		}
		
		/**
		 * The delay until the log file is written.
		 * This allows more entries to be queued for the same commit, which improves performance.
		 * @return 
		 */		
		public static function get delay():Number {
			return timer.delay;
		}
		
		/**
		 * @private
		 * @param value
		 */		
		public static function set delay(value:Number):void {
			var running:Boolean = timer.running;
			
			timer.delay = value;
			
			if (running) timer.start();
		}
		
		/**
		 * Logs a success message.
		 * @param id the identifier of the message (optional)
		 * @param message the success message to log
		 */		
		public static function success(id:*, message:String):void {
			var entry:String = getEntry(SUCCESS, id, message);
		
			queue(entry);
			
			if (traceSuccess) trace(entry);
		}

		/**
		 * Logs an error message.
		 * @param id the identifier of the message (optional)
		 * @param message the error message to log
		 */		
		public static function error(id:*, message:String):void {
			var entry:String = getEntry(ERROR, id, message);
			
			queue(entry);
			
			if (traceError) trace(entry);
		}
		
		/**
		 * Logs a cancel message.
		 * @param id the identifier of the message (optional)
		 * @param message the cancel message to log
		 */		
		public static function cancel(id:*, message:String):void {
			var entry:String = getEntry(CANCEL, id, message);
			
			queue(entry);
			
			if (traceCancel) trace(entry);
		}
		
		/**
		 * Logs a message.
		 * @param message the message to log
		 */		
		public static function print(message:String):void {
			var entry:String = getEntry(PRINT, null, message);
			
			queue(entry);
			
			if (tracePrint) trace(entry);
		}
		
		/**
		 * Clears the log file.
		 * If a transaction is in process, wait until the next available opportunity.
		 */		
		public static function clear():void {
			clearNextTransaction = true;
			
			commit();
		}
		
		/**
		 * @private
		 * @param entry
		 */		
		protected static function queue(entry:String):void {
			buffer += "[" + new Date() + "] " + entry + "\n";
			
			commit();
		}
		
		/**
		 * @private
		 * @param type
		 * @param id
		 * @param message
		 * @return 
		 */		
		protected static function getEntry(type:String, id:*, message:String):String {
			var entry:String = "[" + type + "] ";
			
			if (id && id != -1) {
				entry += "[" + id + "] ";
			}
			
			entry += message;
			
			return entry;
		}
		
		/**
		 * @private
		 */		
		protected static function commit():void {
			if (!inTransaction && timer.delay > 0) {
				inTransaction = true;
				
				timer.reset();
				timer.start();
			} else if (!inTransaction) {
				_commit();
			}
		}
		
		/**
		 * @private
		 */		
		protected static function _commit():void {
			var mode:String;
			
			inTransaction = true;
			
			if (clearNextTransaction) {
				clearNextTransaction = false;
				
				mode = FileMode.WRITE;
			} else {
				mode = FileMode.APPEND;
			}

			fileStream.openAsync(file, mode);
			fileStream.writeUTFBytes(buffer);
			
			buffer = "";
			
			fileStream.close();
		}
		
		/**
		 * @private
		 * @param event
		 */		
		protected static function delayHandler(event:TimerEvent):void {
			_commit();
		}
		
		/**
		 * @private
		 * @param event
		 */		
		protected static function writeCloseHandler(event:Event):void {
			inTransaction = false;
			
			if (buffer) commit();
		}
		
		/**
		 * @private
		 * @param event
		 */		
		protected static function writeErrorHandler(event:IOErrorEvent):void {
			inTransaction = false;
		}
		
		/**
		 * @private
		 * @param event
		 */		
		protected static function uncaughtErrorHandler(event:UncaughtErrorEvent):void {
			if (event.error is Error) {
				error(event.error.errorID, event.error.message + "\n" + event.error.getStackTrace());
			} else if (event.error is ErrorEvent) {
				error(event.error.errorID, event.error.text);
			} else {
				error(-1, event.error);
			}
		}
	}
}