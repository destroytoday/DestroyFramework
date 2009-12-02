package com.destroytoday.util {
	import org.flexunit.Assert;
	
	public class NumberUtilTestCase {
		public function NumberUtilTestCase() {
		}
		
		[Test]
		public function testConfine():void {
			Assert.assertEquals(5, NumberUtil.confine(5, 0, 10));
			Assert.assertEquals(0, NumberUtil.confine(-5, 0, 10));
			Assert.assertEquals(10, NumberUtil.confine(15, 0, 10));
		}
		
		[Test]
		public function testPad():void {
			Assert.assertEquals("372", NumberUtil.pad(372, 3, 0));
			Assert.assertEquals("372.173", NumberUtil.pad(372.173, 3, 0));
			Assert.assertEquals("003.173", NumberUtil.pad(3.173, 3, 0));
			Assert.assertEquals("037.173", NumberUtil.pad(37.173, 3, 0));
			Assert.assertEquals("000.173", NumberUtil.pad(.173, 3, 0));
			Assert.assertEquals("372.000", NumberUtil.pad(372, 0, 3));
			Assert.assertEquals("372.173", NumberUtil.pad(372.173, 0, 3));
			Assert.assertEquals("372.170", NumberUtil.pad(372.17, 0, 3));
			Assert.assertEquals("372.100", NumberUtil.pad(372.1, 0, 3));
			Assert.assertEquals(".173", NumberUtil.pad(.173, 0, 3));
			Assert.assertEquals("003.000", NumberUtil.pad(3, 3, 3));
			Assert.assertEquals("037.170", NumberUtil.pad(37.17, 3, 3));
			Assert.assertEquals("372.170", NumberUtil.pad(372.170, 3, 3));

			Assert.assertEquals("-372", NumberUtil.pad(-372, 3, 0));
			Assert.assertEquals("-372.173", NumberUtil.pad(-372.173, 3, 0));
			Assert.assertEquals("-003.173", NumberUtil.pad(-3.173, 3, 0));
			Assert.assertEquals("-037.173", NumberUtil.pad(-37.173, 3, 0));
			Assert.assertEquals("-000.173", NumberUtil.pad(-.173, 3, 0));
			Assert.assertEquals("-372.000", NumberUtil.pad(-372, 0, 3));
			Assert.assertEquals("-372.173", NumberUtil.pad(-372.173, 0, 3));
			Assert.assertEquals("-372.170", NumberUtil.pad(-372.17, 0, 3));
			Assert.assertEquals("-372.100", NumberUtil.pad(-372.1, 0, 3));
			Assert.assertEquals("-.173", NumberUtil.pad(-.173, 0, 3));
			Assert.assertEquals("-003.000", NumberUtil.pad(-3, 3, 3));
			Assert.assertEquals("-037.170", NumberUtil.pad(-37.17, 3, 3));
			Assert.assertEquals("-372.170", NumberUtil.pad(-372.170, 3, 3));
		}
		
		[Test]
		public function testInsertComma():void {
			Assert.assertEquals(".2", NumberUtil.insertCommas(.2));
			Assert.assertEquals(".72", NumberUtil.insertCommas(.72));
			Assert.assertEquals(".372", NumberUtil.insertCommas(.372));
			Assert.assertEquals("2", NumberUtil.insertCommas(2));
			Assert.assertEquals("72", NumberUtil.insertCommas(72));
			Assert.assertEquals("372", NumberUtil.insertCommas(372));
			
			Assert.assertEquals("3,721", NumberUtil.insertCommas(3721));
			Assert.assertEquals("37,217", NumberUtil.insertCommas(37217));
			Assert.assertEquals("372,173", NumberUtil.insertCommas(372173));
			Assert.assertEquals("3,721,736", NumberUtil.insertCommas(3721736));
			Assert.assertEquals("37,217,369", NumberUtil.insertCommas(37217369));
			Assert.assertEquals("372,173,694", NumberUtil.insertCommas(372173694));
		}
	}
}