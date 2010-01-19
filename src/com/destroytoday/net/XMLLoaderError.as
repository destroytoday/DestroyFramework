package com.destroytoday.net {
	/**
	 * The XMLLoaderError class houses error constants for the XMLLoader class.
	 * @author Jonnie Hallman
	 */	
	public class XMLLoaderError {
		/**
		 * Dispatched when the XML is malformed. 
		 */		
		public static const DATA_PARSE:String = "XMLLoaderError.DATA_PARSE";
		
		/**
		 * Dispatched when XMLLoader hears an IOErrorEvent. 
		 */		
		public static const IO:String = "XMLLoaderError.IO";
		
		/**
		 * Dispatched when XMLLoader hears a SecurityErrorEvent. 
		 */		
		public static const SECURITY:String = "XMLLoaderError.SECURITY";
		
		/**
		 * Dispatched when the currentRetryCount property exceeds the retryCount property. 
		 */		
		public static const RETRY_COUNT:String = "XMLLoaderError.RETRY_COUNT";
		
		/**
		 * @private
		 */		
		public function XMLLoaderError() {
			throw Error("The XMLLoaderError class cannot be instantiated.");
		}
	}
}