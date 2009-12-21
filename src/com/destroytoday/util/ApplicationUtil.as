package com.destroytoday.util {
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;

	/**
	 * The ApplicationUtil class is a collection of methods for managing the application.
	 * @author Jonnie Hallman
	 */	
	public class ApplicationUtil {
		/**
		 * @private
		 */		
		public function ApplicationUtil() {
			throw Error("The ApplicationUtil class cannot be instantiated.");
		}
		
		/**
		 * Returns the application's version specified in the application descriptor.
		 * @return 
		 */		
		public static function getVersion():String {
			var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = xml.namespace();
			
			return xml.ns::version;
		}
		
		/**
		 * Closes all open windows.
		 * This method must be called on PC in order to properly quit the application.
		 * @param andQuit Sets autoExit to true prior to closing the windows.
		 */		
		public static function closeOpenWindows(andQuit:Boolean = false):void {
			if (andQuit) NativeApplication.nativeApplication.autoExit = true;
			
			for each (var nativeWindow:NativeWindow in NativeApplication.nativeApplication.openedWindows) {
				nativeWindow.close();
			}
		}
	}
}