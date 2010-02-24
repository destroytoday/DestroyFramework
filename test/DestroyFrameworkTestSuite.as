package {
	import asunit.framework.TestSuite;
	
	import com.destroytoday.display.GroupTestCase;
	import com.destroytoday.display.SpritePlusBoundsTestCase;
	import com.destroytoday.display.SpritePlusTestCase;
	
	[Suite]
	public class DestroyFrameworkTestSuite {
		public var spritePlusTestCase:SpritePlusTestCase;
		public var spritePlusBoundsTestCase:SpritePlusBoundsTestCase;
		public var groupTestCase:GroupTestCase;
		
		public function DestroyFrameworkTestSuite() {
		}
	}
}