package test.com.destroytoday.util {
	import com.destroytoday.util.StringUtil;
	
	import org.flexunit.Assert;
	
	public class StringUtilTestCase {
		public function StringUtilTestCase() {
		}
		
		[Test]
		public function testTruncate():void {
			Assert.assertNull(StringUtil.truncate(null, 30));
			Assert.assertEquals("foo bar", StringUtil.truncate("foo bar", 30));
			Assert.assertEquals("foo...", StringUtil.truncate("foo bar", 3));
		}
		
		[Test]
		public function testAddSlashes():void {
			Assert.assertNull(StringUtil.addSlashes(null));
			Assert.assertEquals("", StringUtil.addSlashes(""));
			Assert.assertEquals("\"foo\" bar", StringUtil.addSlashes("\"foo\" bar", null));
			Assert.assertEquals("\"foo\" bar", StringUtil.addSlashes("\"foo\" bar", ""));
			Assert.assertEquals("foo", StringUtil.addSlashes("foo"));
			
			// Result should look like foo\'s bar
			Assert.assertEquals("foo\\\'s bar", StringUtil.addSlashes("foo's bar", "'"));
			
			// Result should look like \"foo\" bar
			Assert.assertEquals("\\\"foo\\\" bar", StringUtil.addSlashes("\"foo\" bar"));
			
			// Result should look like \foo\-\bar
			Assert.assertEquals("\\foo\\-\\bar", StringUtil.addSlashes("foo-bar", "b-f"));
			
			// Result should look like \foo\^\bar
			Assert.assertEquals("\\foo\\^\\bar", StringUtil.addSlashes("foo^bar", "^fb"));
			
			// Result should look like \[\foo\] \bar
			Assert.assertEquals("\\[\\foo\\] \\bar", StringUtil.addSlashes("[foo] bar", "b][f"));
			
			// Result should look like \(\foo\) \bar
			Assert.assertEquals("\\(\\foo\\) \\bar", StringUtil.addSlashes("(foo) bar", "(bf)"));
			
			// Result should look like \foo \bar\?
			Assert.assertEquals("\\foo \\bar\\?", StringUtil.addSlashes("foo bar?", "fb?"));
			
			// Result should look like \foo \bar\.
			Assert.assertEquals("\\foo \\bar\\.", StringUtil.addSlashes("foo bar.", "fb."));
			
			// Result should look like \foo\+\bar
			Assert.assertEquals("\\foo\\+\\bar", StringUtil.addSlashes("foo+bar", "fb+"));
		}
	}
}