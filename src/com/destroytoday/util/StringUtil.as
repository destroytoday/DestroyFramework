package com.destroytoday.util {
	/**
	 * The StringUtil class is a collection of methods for manipulating and analyzing strings.
	 * @author Jonnie Hallman
	 */	
	public class StringUtil {
		public static const URL_REGEX:RegExp = /(?<!@)(\b)((((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp):\/\/)|(www\.))*((([a-zA-Z0-9_-]+\.)+(aero|asia|biz|cat|com|coop|edu|gov|int|info|jobs|mobi|museum|name|net|org|pro|tel|travel|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bl|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mf|mg|mh|mil|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|za|zm|zw))|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(\/[a-zA-Z0-9\+\&amp;%_\.\/\-\~\-\#\?\:\=,\!]*)?(\/|\b))/ig;
		
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
		
		public static function capitalize(str:String):String
		{
			return str.substr(0, 1).toUpperCase() + str.substr(1);
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
		
		public static function stripHTML(str:String):String
		{
			return str.replace(/<[^>]+>/g, "");
		}
	}
}