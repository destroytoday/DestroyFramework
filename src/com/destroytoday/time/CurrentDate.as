package com.destroytoday.time {
	import flash.utils.getTimer;

	/**
	 * The CurrentDate class consists of static methods that recycle a Date instance and return the current date.
	 * @author Jonnie Hallman
	 */	
	public class CurrentDate {
		/**
		 * @private 
		 */		
		protected static var _currentDate:Date;
		
		/**
		 * Used to counter the time that elapsed prior to calling a method.
		 * @private 
		 */		
		protected static var offsetTimestamp:int = -1;
		
		/**
		 * @private
		 */		
		public function CurrentDate() {
			throw Error("The CurrentDate class cannot be instantiated");
		}
		
		/**
		 * @private
		 * @return 
		 */		
		protected static function get currentDate():Date {
			if (offsetTimestamp == -1) offsetTimestamp = getTimer();
			
			if (!_currentDate) _currentDate = new Date();
			
			_currentDate.milliseconds += getTimer() - offsetTimestamp;
			
			return _currentDate;
		}
		
		/**
		 * Indicates whether or not the current time is AM.
		 * @return 
		 */		
		public static function get antemeridian():Boolean {
			return currentDate.hours < 12;
		}
		
		/**
		 * Indicates whether or not the current time is PM.
		 * @return 
		 */		
		public static function get postmeridian():Boolean {
			return currentDate.hours >= 12;
		}
		
		/**
		 * The day of the month (an integer from 1 to 31) according to local time.
		 * @return 
		 */		
		public static function get date():Number {
			return currentDate.getDate();
		}
		
		/**
		 * The day of the week (0 for Sunday, 1 for Monday, and so on) according to local time.
		 * @return 
		 */		
		public static function get day():Number {
			return currentDate.getDay();
		}
		
		/**
		 * The full year (a four-digit number, such as 2000) according to local time.
		 * @return 
		 */		
		public static function get fullYear():Number {
			return currentDate.getFullYear();
		}
		
		/**
		 * The hour (an integer from 0 to 23) of the day according to local time.
		 * @return 
		 */		
		public static function get hours():Number {
			return currentDate.getHours();
		}
		
		/**
		 * The milliseconds (an integer from 0 to 999) according to local time.
		 * @return 
		 */		
		public static function get milliseconds():Number {
			return currentDate.getMilliseconds();
		}
		
		/**
		 * The minutes (an integer from 0 to 59) according to local time.
		 * @return 
		 */		
		public static function get minutes():Number {
			return currentDate.getMinutes();
		}
		
		/**
		 * The month (0 for January, 1 for February, and so on) according to local time.
		 * @return 
		 */		
		public static function get month():Number {
			return currentDate.getMonth();
		}
		
		/**
		 * The seconds (an integer from 0 to 59) according to local time.
		 * @return 
		 */		
		public static function get seconds():Number {
			return currentDate.getSeconds();
		}
		
		/**
		 * The number of milliseconds since midnight January 1, 1970, universal time.
		 * @return 
		 */		
		public static function get time():Number {
			return currentDate.getTime();
		}
		
		/**
		 * The difference, in minutes, between universal time (UTC) and the computer's local time.
		 * @return 
		 */		
		public static function get timezoneOffset():Number {
			return currentDate.getTimezoneOffset();
		}
		
		/**
		 * The day of the month (an integer from 1 to 31) according to universal time (UTC).
		 * @return 
		 */		
		public static function get dateUTC():Number {
			return currentDate.getUTCDate();
		}
		
		/**
		 * The day of the week (0 for Sunday, 1 for Monday, and so on) according to universal time (UTC).
		 * @return 
		 */		
		public static function get dayUTC():Number {
			return currentDate.getUTCDay();
		}
		
		/**
		 * The four-digit year according to universal time (UTC).
		 * @return 
		 */		
		public static function get fullYearUTC():Number {
			return currentDate.getUTCFullYear();
		}
		
		/**
		 * The hour (an integer from 0 to 23) of the day of according to universal time (UTC).
		 * @return 
		 */		
		public static function get hoursUTC():Number {
			return currentDate.getUTCHours();
		}
		
		/**
		 * The milliseconds (an integer from 0 to 999) according to universal time (UTC).
		 * @return 
		 */		
		public static function get millisecondsUTC():Number {
			return currentDate.getUTCMilliseconds();
		}
		
		/**
		 * The minutes (an integer from 0 to 59) according to universal time (UTC).
		 * @return 
		 */		
		public static function get minutesUTC():Number {
			return currentDate.getUTCMinutes();
		}
		
		/**
		 * The month (0 [January] to 11 [December]) according to universal time (UTC).
		 * @return 
		 */		
		public static function get monthUTC():Number {
			return currentDate.getUTCMonth();
		}
		
		/**
		 * The seconds (an integer from 0 to 59) according to universal time (UTC).
		 * @return 
		 */		
		public static function get secondsUTC():Number {
			return currentDate.getUTCSeconds();
		}
		
		/**
		 * Returns a string representation of the day and date only, and does not include the time or timezone.
		 * @return 
		 */		
		public static function toDateString():String {
			return currentDate.toDateString();
		}
		
		/**
		 * Returns a String representation of the day and date only, and does not include the time or timezone.
		 * @return 
		 */		
		public static function toLocaleDateString():String {
			return currentDate.toLocaleDateString();
		}
		
		/**
		 * Returns a String representation of the day, date, time, given in local time.
		 * @return 
		 */		
		public static function toLocaleString():String {
			return currentDate.toLocaleString();
		}
		
		/**
		 * Returns a String representation of the time only, and does not include the day, date, year, or timezone.
		 * @return 
		 */		
		public static function toLocaleTimeString():String {
			return currentDate.toLocaleTimeString();
		}
		
		/**
		 * Returns a String representation of the day, date, time, and timezone.
		 * @return 
		 */		
		public static function toString():String {
			return currentDate.toString();
		}
		
		/**
		 * Returns a String representation of the time and timezone only, and does not include the day and date.
		 * @return 
		 */		
		public static function toTimeString():String {
			return currentDate.toTimeString();
		}
		
		/**
		 * Returns a String representation of the day, date, and time in universal time (UTC).
		 * @return 
		 */		
		public static function toUTCString():String {
			return currentDate.toUTCString();
		}
		
		/**
		 * Returns the number of milliseconds since midnight January 1, 1970, universal time, for a Date object.
		 * @return 
		 */		
		public static function valueOf():Number {
			return currentDate.valueOf();
		}
	}
}