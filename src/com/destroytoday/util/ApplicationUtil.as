package com.destroytoday.util {
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.system.Capabilities;

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
		 * Indicates whether the running OS is a Mac
		 * @return
		 */
		public static function get mac():Boolean {
			return Capabilities.os.toLowerCase().indexOf("mac os") != -1;
		}
		
		/**
		 * Indicates whether the running OS is a PC
		 * @return
		 */
		public static function get pc():Boolean {
			return Capabilities.os.toLowerCase().indexOf("mac os") == -1;
		}

		/**
		 * Returns the application's version specified in the application descriptor.
		 * @return
		 */
		public static function get version():String {
			var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = xml.namespace();

			return xml.ns::version;
		}

		/**
		 * Returns the application's id specified in the application descriptor.
		 * @return
		 */
		public static function get id():String {
			var xml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = xml.namespace();

			return xml.ns::id;
		}
	}
}