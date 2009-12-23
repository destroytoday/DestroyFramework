package com.destroytoday.timer {

	/**
	 * @author Jonnie Hallman
	 */
	public class AsyncLoopAction {
		/**
		 * Continues the loop.
		 */
		public static const CONTINUE:String = "continue";

		/**
		 * Ends the loop.
		 */
		public static const END:String = "end";

		/**
		 * @private
		 */
		public function AsyncLoopAction() {
			throw Error("The AsyncLoopAction class cannot be instantiated.");
		}
	}
}