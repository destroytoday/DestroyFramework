package com.destroytoday.util {
	/**
	 * The NumberUtil class is a collection of methods for manipulating and analyzing numbers.
	 * @author Jonnie Hallman
	 */	
	public class NumberUtil {
		/**
		 * @private
		 */		
		public function NumberUtil() {
			throw new Error("The NumberUtil class cannot be instantiated.");
		}
		
		/**
		 * Resticts the <code>value</code> to the <code>min</code> and <code>max</code> 
		 * @param value the number to restrict
		 * @param min the minimum number for <code>value</code> to be
		 * @param max the maximmum number for <code>value</code> to be
		 * @return 
		 */		
		public static function confine(value:Number, min:Number, max:Number):Number {
			return value < min ? min : (value > max ? max : value);
		}
		
		/**
		 * Pads the <code>value</code> with the set number of digits before and after the point.
		 * If the number of digits in the integer of <code>value</code> is less than <code>beforePoint</code>, the remaining digits are filled with zeros.
		 * If the number of digits in the decimal of <code>value</code> is less than <code>afterPoint</code>, the remaning digits are filled with zeros.
		 * @param value the number to pad
		 * @param beforePoint the number of digits to pad before the point
		 * @param afterPoint the number of digits to pad after the point
		 * @return <code>value</code> padded as a <code>String</code>
		 * @example
		 * <listing version="3.0">
		 * NumberUtil.pad(.824, 0, 5); // returns ".82400"
		 * NumberUtil.pad(9, 3, 2); // returns "009.00"
		 * NumberUtil.pad(2835.3, 4, 2); // returns "2835.30"
		 * </listing>
		 */		
		public static function pad(value:Number, beforePoint:uint, afterPoint:uint = 0):String {
			// separate the integer from the decimal
			var valueArray:Array = String(value).split(".");
			
			var integer:String = valueArray[0];
			
			// determine the sign of the value
			var negative:Boolean = integer.substr(0, 1) == "-";
			
			// remove the "-" if it exists
			if (negative) integer = integer.substr(1);
			
			// treat zeros as empty, so integer.length doesn't return 1 when integer is 0
			if (integer == "0") {
				integer = "";
			}
			
			var len:int = integer.length;
			
			// determine how many times "0" needs to be prepended
			var zeros:int = Math.max(0, beforePoint - len);
			
			// prepend "0" until zeros == 0
			while (zeros--) integer = "0" + integer;
			
			var decimal:String;
			
			// if a point didn't exist or the decimal is 0, empty the decimal
			if (valueArray.length == 1 || valueArray[1] == "0") {
				decimal = "";
			} else {
				decimal = valueArray[1];
			}
				
			len = decimal.length;
			
			// determine how many times "0" needs to be appended
			zeros = Math.max(0, afterPoint - len);
			
			// append "0" until zeros == 0
			while (zeros--) decimal += "0";
			
			// set sign if negative
			var sign:String = negative ? "-" : "";
			
			// set point if a decimal exists (or afterPoint > 0, determined earlier)
			var point:String = decimal ? "." : "";
			
			return sign + integer + point + decimal;
		}
		
		/**
		 * Rounds a number to the nearest nth, where <code>digits</code> is n / 10.
		 * @param value the number to round
		 * @param digits the number of digits to show after the point
		 * @return 
		 */		
		public static function round(value:Number, digits:int):Number {
			digits = Math.pow(10, digits);
			
			return Math.round(value * digits) / digits;
		}
		
		/**
		 * Inserts commas every three digits in the integer of <code>value</code> 
		 * @param value the number to insert commas into
		 * @return <code>value</code> as a <code>String</code> formatted with commas
		 */		
		public static function insertCommas(value:Number):String {
			// convert the value to a string
			var valueString:String = String(value);
			
			// determine the location of the point
			var commaIndex:int = valueString.indexOf(".");
			
			// if a point doesn't exist, consider it to be at the end of the value
			if (commaIndex == -1) commaIndex = valueString.length;
			
			do {
				// move to the left three digits
				commaIndex -= 3;
				
				// if index is beyond the beginning of the value, end the loop
				if (commaIndex <= 0) break;
				
				// insert the comma
				valueString = valueString.substring (0, commaIndex) + "," + valueString.substr (commaIndex);
			} while (true);
			
			// remove "0" if value is a decimal
			if (valueString.substr(0, 2) == "0.") valueString = valueString.substr(1);
			
			return valueString;
		}
	}
}