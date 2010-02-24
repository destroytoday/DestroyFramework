package com.destroytoday.display {

	public class GroupArrangeType {
		public static const NONE:String = "none";

		public static const LEFT_RIGHT:String = "leftRight";

		public static const RIGHT_LEFT:String = "rightLeft";

		public static const TOP_BOTTOM:String = "topBottom";

		public static const BOTTOM_TOP:String = "bottomTop";

		public static const HORIZONTAL_JUSTIFY:String = "horizontalJustify";

		public static const VERTICAL_JUSTIFY:String = "verticalJustify";

		public function GroupArrangeType() {
			throw Error("The GroupArrangeType instance cannot be instantiated.");
		}
	}
}