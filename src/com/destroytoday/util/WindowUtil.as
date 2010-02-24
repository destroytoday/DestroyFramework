package com.destroytoday.util {
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.Screen;
	import flash.geom.Rectangle;

	/**
	 * The WindowUtil class is a collection of methods for manipulating and analyzing windows.
	 * @author Jonnie Hallman
	 */	
	public class WindowUtil {
		public function WindowUtil() {
			throw Error("The WindowUtil class cannot be instantiated.");
		}

		/**
		 * Centers a window on the screen.
		 * @param window the window to center
		 * @param screen the screen to center on
		 * If null, Screen.mainScreen is used.
		 * @param xOffset the number of pixels to offset on the x-axis
		 * @param yOffset the number of pixels to offset on the y-axis
		 *
		 */
		public static function center(window:NativeWindow, screen:Screen = null, xOffset:Number = 0.0, yOffset:Number = 0.0):void {
			if (!screen)
				screen = Screen.mainScreen;

			var bounds:Rectangle = screen.visibleBounds;

			window.x = (bounds.right - window.width) * 0.5 + xOffset;
			window.y = (bounds.bottom - window.height) * 0.5 + yOffset;
		}

		/**
		 * Closes all open windows.
		 * This method must be called on PC in order to properly quit the application.
		 * @param andQuit Sets autoExit to true prior to closing the windows.
		 */
		public static function closeAll(quit:Boolean = false):void {
			if (quit)
				NativeApplication.nativeApplication.autoExit = true;

			for each (var nativeWindow:NativeWindow in NativeApplication.nativeApplication.openedWindows) {
				nativeWindow.close();
			}
		}
		
		/**
		 * Indicates whether a window is completely off the screen(s).
		 * @param window
		 * @return 
		 */		
		public static function isOffScreen(window:NativeWindow):Boolean {
			return Screen.getScreensForRectangle(window.bounds).length == 0;
		}
		
		/**
		 * Indicates whether a window is touching multiple screens.
		 * @param window
		 * @return 
		 */		
		public static function isOnMultipleScreens(window:NativeWindow):Boolean {
			return Screen.getScreensForRectangle(window.bounds).length > 1;
		}
		
		/**
		 * Returns the screen that the window lies on.
		 * @param window
		 * @return 
		 */		
		public static function getScreen(window:NativeWindow):Screen {
			var bounds:Rectangle = new Rectangle(window.bounds.left + window.bounds.width * 0.5, window.bounds.top + window.bounds.height * 0.5, 1.0, 1.0);
			var screens:Array = Screen.getScreensForRectangle(bounds);	

			return screens ? screens[0] : null;
		}
	}
}