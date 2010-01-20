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
		 * @private
		 */		
		public function XMLLoaderError() {
			throw Error("The XMLLoaderError class cannot be instantiated.");
		}
	}
}