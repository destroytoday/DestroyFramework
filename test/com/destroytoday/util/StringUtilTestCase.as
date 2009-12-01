package com.destroytoday.util {
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
			Assert.assertEquals("foo\\\'s bar", StringUtil.addSlashes("foo's bar", "'"));
			Assert.assertEquals("\\\"foo\\\" bar", StringUtil.addSlashes("\"foo\" bar"));
			Assert.assertEquals("\\foo\\-\\bar", StringUtil.addSlashes("foo-bar", "b-f"));
			Assert.assertEquals("\\foo\\^\\bar", StringUtil.addSlashes("foo^bar", "^fb"));
			Assert.assertEquals("\\[\\foo\\] \\bar", StringUtil.addSlashes("[foo] bar", "b][f"));
			Assert.assertEquals("\\(\\foo\\) \\bar", StringUtil.addSlashes("(foo) bar", "(bf)"));
			Assert.assertEquals("\\foo \\bar\\?", StringUtil.addSlashes("foo bar?", "fb?"));
			Assert.assertEquals("\\foo \\bar\\.", StringUtil.addSlashes("foo bar.", "fb."));
			Assert.assertEquals("\\foo\\+\\bar", StringUtil.addSlashes("foo+bar", "fb+"));
		}
		
		[Test]
		public function testStripSlashes():void {
			Assert.assertNull(StringUtil.stripSlashes(null));
			Assert.assertEquals("", StringUtil.stripSlashes(""));
			Assert.assertEquals("\\\"foo\\\" bar", StringUtil.stripSlashes("\\\"foo\\\" bar", null));
			Assert.assertEquals("\\\"foo\\\" bar", StringUtil.stripSlashes("\\\"foo\\\" bar", ""));
			Assert.assertEquals("foo", StringUtil.stripSlashes("foo"));
			Assert.assertEquals("foo's bar", StringUtil.stripSlashes("foo\\'s bar", "'"));
			Assert.assertEquals("\"foo\" bar", StringUtil.stripSlashes("\\\"foo\\\" bar"));
			Assert.assertEquals("foo-bar", StringUtil.stripSlashes("\\foo\\-\\bar", "b-f"));
			Assert.assertEquals("foo^bar", StringUtil.stripSlashes("\\foo\\^\\bar", "^fb"));
			Assert.assertEquals("[foo] bar", StringUtil.stripSlashes("\\[\\foo\\] \\bar", "b][f"));
			Assert.assertEquals("(foo) bar", StringUtil.stripSlashes("\\(\\foo\\) \\bar", "(bf)"));
			Assert.assertEquals("foo bar?", StringUtil.stripSlashes("\\foo \\bar\\?", "fb?"));
			Assert.assertEquals("foo bar.", StringUtil.stripSlashes("\\foo \\bar\\.", "fb."));
			Assert.assertEquals("foo+bar", StringUtil.stripSlashes("\\foo\\+\\bar", "fb+"));
		}
	}
}