package com.destroytoday.net {
	/**
	 * The GenericLoaderError class houses error constants for loader classes.
	 * @author Jonnie Hallman
	 */	
	public class GenericLoaderError {
		/**
		 * Dispatched when a loader hears an IOErrorEvent. 
		 */		
		public static const IO:String = "GenericLoaderError.IO";
		
		/**
		 * Dispatched when loader hears a SecurityErrorEvent. 
		 */		
		public static const SECURITY:String = "GenericLoaderError.SECURITY";
		
		/**
		 * Dispatched when the currentRetryCount property exceeds the retryCount property. 
		 */		
		public static const RETRY_COUNT:String = "GenericLoaderError.RETRY_COUNT";
		
		/**
		 * @private
		 */		
		public function GenericLoaderError() {
			throw Error("The GenericLoaderError class cannot be instantiated.");
		}
	}
}