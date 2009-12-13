package com.destroytoday.util {
	/*
	The MIT License
	
	Copyright (c) 2009 Jonnie Hallman
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	*/
	
	/**
	 * The StringUtil class is a collection of methods for manipulating and analyzing strings.
	 * @author Jonnie Hallman
	 */	
	public class StringUtil {
		/**
		 * Characters to automatically double slash because they disrupt the regular expression
		 */		
		public static const REGEX_UNSAFE_CHARS:String = "-^[]\\";
		
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
			// return the string if str is null, an empty str is okay
			if (str == null) return str;

			// append the ellipsis if the length of the string is greater than len, otherwise return str unaltered
			return (str.length > len) ? str.substr(0, len) + "..." : str;
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
				
				if (chars.indexOf(unsafeChar) != -1) chars = chars.replace(REGEX_UNSAFE_CHARS, "\\" + unsafeChar);
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