package com.destroytoday.util {

	/**
	 * The DateUtil class is a collection of methods for manipulating dates.
	 * @author Jonnie Hallman
	 */	
	public class DateUtil {
		
		//
		// Milliseconds
		//
		
		public static const YEAR_IN_MILLISECONDS:Number = 31536000000.0;
		
		public static const THIRTY_ONE_DAY_MONTH_IN_MILLISECONDS:Number = 2678400000.0;
		
		public static const THIRTY_DAY_MONTH_IN_MILLISECONDS:Number = 2592000000.0;
		
		public static const TWENTY_EIGHT_DAY_MONTH_IN_MILLISECONDS:Number = 2419200000.0;
		
		public static const WEEK_IN_MILLISECONDS:Number = 604800000.0;
		
		public static const DAY_IN_MILLISECONDS:Number = 86400000.0;
		
		public static const HOUR_IN_MILLISECONDS:Number = 3600000.0;
		
		public static const MINUTE_IN_MILLISECONDS:Number = 60000.0;
		
		
		//
		// Seconds
		//
		
		public static const YEAR_IN_SECONDS:Number = 31536000;
		
		public static const THIRTY_ONE_DAY_MONTH_IN_SECONDS:Number = 2678400;
		
		public static const THIRTY_DAY_MONTH_IN_SECONDS:Number = 2592000;
		
		public static const TWENTY_EIGHT_DAY_MONTH_IN_SECONDS:Number = 2419200;
		
		public static const WEEK_IN_SECONDS:Number = 604800;
		
		public static const DAY_IN_SECONDS:Number = 86400;
		
		public static const HOUR_IN_SECONDS:Number = 3600;
		
		public static const MINUTE_IN_SECONDS:Number = 60;
		
		
		//
		// Reference arrays
		//

		protected static const monthNames:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

		protected static const dayNames:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

		/**
		 * @private
		 */		
		public function DateUtil() {
			throw Error("The DateFormat class cannot be instantiated.");
		}

		/**
		 * Returns the English name of the provided month.
		 * @param month the index of the month, starting at zero
		 * @return 
		 */		
		public static function getMonthName(month:int):String {
			return monthNames[month];
		}

		/**
		 * Returns the English name of the provided day.
		 * @param day the index of the day, where zero returns 'Sunday' and six returns 'Saturday'
		 * @return 
		 */		
		public static function getDayName(day:int):String {
			return dayNames[day];
		}

		/**
		 * Returns the rounded down date where the time is 12:00am.
		 * If a date is not provided, the current date is used.
		 * @param date the date to round down
		 * @return 
		 */		
		public static function floor(date:Date = null):Date {
			if (!date)
				date = new Date();

			date.hours = 0.0;
			date.minutes = 0.0;
			date.seconds = 0.0;
			date.milliseconds = 0.0;

			return date;
		}

		/**
		 * Returns the rounded up date where the time is 12:00am.
		 * If a date is not provided, the current date is used.
		 * @param date the date to round up
		 * @return 
		 */		
		public static function ceil(date:Date = null):Date {
			if (!date)
				date = new Date();

			date.date += 1.0;
			date.hours = 0.0;
			date.minutes = 0.0;
			date.seconds = 0.0;
			date.milliseconds = 0.0;

			return date;
		}
	}
}