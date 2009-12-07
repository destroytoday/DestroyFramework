package com.destroytoday.desktop {
	import com.destroytoday.events.EventDispatcherPlus;
	import com.destroytoday.events.ScreenCaptureEvent;
	import com.destroytoday.util.NumberUtil;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	/**
	 * Dispatched when the screen capture is complete. 
	 */	
	[Event(name="capture", type="com.destroytoday.events.ScreenCaptureEvent")]

	/**
	 * The ScreenCapture class is used to take screenshots with a large number of options.
	 * It currently supports only Mac and requires AIR 2.0.
	 * @author Jonnie Hallman
	 */	
	public class ScreenCapture extends EventDispatcherPlus {
		/**
		 * The mode for capturing the screen.
		 * Options include the entire screen(s), selection via click/drag, window, or interactive.
		 */		
		public var mode:String = ScreenCaptureMode.SCREEN;
		
		/**
		 * The filetype of the screenshot image.
		 * Options include png, jpg, gif, pdf, and tiff.
		 * @default png
		 */		
		public var imageFormat:String = ScreenCaptureImageFormat.PNG;
		
		/**
		 * Specifies whether to include the cursor in the screenshot. (Screen mode only) 
		 */		
		public var includeCursor:Boolean;
		
		/**
		 * Specifies whether to capture only the main screen. (Screen mode only) 
		 */		
		public var mainMonitorOnly:Boolean;
		
		/**
		 * Specifies whether to graphically display errors using system alerts.
		 */		
		public var displayErrors:Boolean;
		
		/**
		 * Specifies whether to hide the window shadow. (Window mode only) 
		 */		
		public var hideWindowShadow:Boolean;
		
		/**
		 * Specifies whether to mute the screen capture sound. 
		 */		
		public var muteSound:Boolean;
		
		/**
		 * The amount of time to delay the screen capture in milliseconds.
		 * The delay is invoked by the system, preventing screen captures while the delay is running.
		 */		
		public var delay:int;
		
		/**
		 * @private 
		 */		
		protected var _nativeProcess:NativeProcess;
		
		/**
		 * @private 
		 */		
		protected var nativeProcessInfo:NativeProcessStartupInfo;
		
		/**
		 * @private 
		 */		
		protected var storageType:String;
		
		/**
		 * @private 
		 */		
		protected var file:File;
		
		/**
		 * The NativeProcess instance responsible for the screen captures.
		 * @return 
		 */		
		public function get nativeProcess():NativeProcess { return _nativeProcess; }
		
		/**
		 * Creates an instance of ScreenCapture.
		 */		
		public function ScreenCapture(){
			_nativeProcess = new NativeProcess();
			nativeProcessInfo = new NativeProcessStartupInfo();
			file = new File();
			
			// set executable if Mac
			if (Capabilities.os.toLowerCase().indexOf("mac") != -1) {
				nativeProcessInfo.executable = new File("/usr/sbin/screencapture");
			}
			
			nativeProcessInfo.arguments = new Vector.<String>();
			
			// listen for completed screen capture process
			_nativeProcess.addEventListener(Event.STANDARD_OUTPUT_CLOSE, saveCompleteHandler);
			
			// listen for any errors
			_nativeProcess.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, saveErrorHandler);
		}
		
		/**
		 * @private
		 */		
		protected function capture(file:File = null):void {
			var args:Vector.<String> = nativeProcessInfo.arguments;
			
			// empty arguments
			args.length = 0;
			
			if (includeCursor) args.push("-C");
			if (mainMonitorOnly) args.push("-m");
			if (muteSound) args.push("-x");
			
			switch (mode) {
				case ScreenCaptureMode.SELECTION: args.push("-s"); break;
				case ScreenCaptureMode.WINDOW: args.push("-W"); break;
				case ScreenCaptureMode.INTERACTIVE: args.push("-i"); break;
			}
			
			if (imageFormat != ScreenCaptureImageFormat.PNG) args.push("-t" + imageFormat);
			
			// convert delay to seconds
			if (delay > 0) args.push("-T" + (delay * .001));

			if (displayErrors) args.push("-d");
			
			if (hideWindowShadow) args.push("-o");
			
			if (file) {
				// slash spaces
				args.push(file.nativePath.replace(" ", "\ "));
			} else {
				args.push("-c");
			}

			_nativeProcess.start(nativeProcessInfo);
		}
		
		/**
		 * Captures the screen and saves to a file.
		 * @param path
		 * @return false if the screen capture process is running
		 */		
		public function saveToFile(path:String = null):Boolean {
			// cancel and return false if the process is running
			if (_nativeProcess.running) return false;
			
			storageType = ScreenCaptureStorageType.FILE;
			
			// if path is null, save to the desktop
			file.nativePath = path || File.desktopDirectory.nativePath;
			
			// if the path points to a directory, use a timestamp as the filename
			if (file.isDirectory) {
				var date:Date = new Date();
				
				var year:String = String(date.fullYear);
				var month:String = NumberUtil.pad(date.month + 1, 2);
				var day:String = NumberUtil.pad(date.date, 2);
				
				var hour:String = NumberUtil.pad(date.hours, 2);
				var minute:String = NumberUtil.pad(date.minutes, 2);
				var second:String = NumberUtil.pad(date.seconds, 2);
				
				file.nativePath += File.separator + year + "-" + month + "-" + day + " " + hour + "." + minute + "." + second + "." + imageFormat;
			}
			
			capture(file);
			
			return true;
		}
		
		/**
		 * Captures the screen and saves to the clipboard. 
		 * @return false if the screen capture process is running
		 */		
		public function saveToClipboard():Boolean {
			// cancel and return false if the process is running
			if (_nativeProcess.running) return false;
			
			storageType = ScreenCaptureStorageType.CLIPBOARD;
			
			capture();
			
			return true;
		}
		
		/**
		 * @private
		 */		
		protected function saveCompleteHandler(event:Event):void {
			var captureEvent:ScreenCaptureEvent = new ScreenCaptureEvent(ScreenCaptureEvent.CAPTURE);
			
			// specify whether the capture is saved to a file or the clipboard
			captureEvent.storageType = storageType;
			
			if (storageType == ScreenCaptureStorageType.FILE) {
				captureEvent.path = file.nativePath;
				captureEvent.url = file.url;
			}
			
			dispatchEvent(captureEvent);
		}
		
		/**
		 * @private
		 */		
		protected function saveErrorHandler(event:IOErrorEvent):void {
			trace ("error!", event);
		}
	}
}