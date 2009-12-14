package com.destroytoday.util {
	/**
	 * The StringUtil class is a collection of methods for manipulating and analyzing strings.
	 * @author Jonnie Hallman
	 */	
	public class StringUtil {
		/**
		 * Characters to automatically double slash because they disrupt the regular expression
		 */		
		public static const REGEX_UNSAFE_CHARS:String = "\\-^[]";
		
		protected static const TRIM_RIGHT_REGEX:RegExp = /[\s]+$/g;
		
		/**
		 * @private
		 */		
		public function StringUtil() {
			throw new Error("The StringUtil class cannot be instantiated.");
		}
		
		/**
		 * Returns the truncated string with an appended ellipsis (...) if the length of <code>str</code> is greater than <code>len</code>.
		 * If the length of <code>str</code> is less than or equal to <code>len</code>, the method returns <code>str</code> unaltered.
		 * @param str the string to truncate
		 * @param len the length to limit the string to
		 * @return 
		 */		
		public static function truncate(str:String, len:int):String {
			// return the string if str is null, empty, or the length of str is less than or equal to len
			if (!str || str.length <= len) return str;
			
			// short str to len
			str = str.substr(0, len);
			
			// trim the right side of whitespace
			str = str.replace(TRIM_RIGHT_REGEX, "");

			// append the ellipsis
			return str + "...";
		}
		
		/**
		 * @private
		 * @param chars
		 * @return 
		 */		
		protected static function slashUnsafeChars(chars:String):String {
			var unsafeChar:String;
			var m:uint = REGEX_UNSAFE_CHARS.length;

			for (var i:uint = 0; i < m; ++i) {
				unsafeChar = REGEX_UNSAFE_CHARS.substr(i, 1);
				
				if (chars.indexOf(unsafeChar) != -1) chars = chars.replace(unsafeChar, "\\" + unsafeChar);
			}
			
			return chars;
		}
		
		/**
		 * Returns the string with slashes prepended to all characters specified in the <code>chars</code> parameter
		 * @param str the string to return slashed
		 * @param chars the string of chars to slash
		 * @return 
		 */		
		public static function addSlashes(str:String, chars:String = "\""):String {
			// return the unaltered string if str or chars are null or empty
			if (!str || !chars) return str;

			// slash unsafe characters
			chars = slashUnsafeChars(chars);

			// build the regular expression that handles the slashing
			var regex:RegExp = new RegExp("([" + chars + "])", "g");

			// add the slashes to the specified characters
			return str.replace(regex, "\\$1");
		}
		
		/**
		 * Returns the string with slashes removed from all characters specified in the <code>chars</code> parameter
		 * @param str the string to return stripped of slashes
		 * @param chars the string of chars to remove slashes from
		 * @return 
		 */
		public static function stripSlashes(str:String, chars:String = "\""):String {
			// return the unaltered string if str or chars are null or empty
			if (!str || !chars) return str;
			
			// slash unsafe characters
			chars = slashUnsafeChars(chars);
			
			// build the regular expression that removes the slashes
			var regex:RegExp = new RegExp("\\\\([" + chars + "])", "g");
			
			// strip the slashes from the specified characters
			return str.replace(regex, "$1");
		}
	}
}