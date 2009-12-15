package com.destroytoday.text {
	
	import org.flexunit.Assert;
	
	public class TextFieldPlusTestCase {
		public function TextFieldPlusTestCase() {
		}
		
		[Test]
		public function testText():void {
			var textfield:TextFieldPlus = new TextFieldPlus();
			
			textfield.text = "Jonnie developed this class.";
			
			Assert.assertEquals("Jonnie developed this class.", textfield.text);
			
			textfield.text += " He really did!";
			
			Assert.assertEquals("Jonnie developed this class. He really did!", textfield.text);
			
			textfield.beginText();
			textfield.text += " Really?";
			textfield.text += " Yes.";
			textfield.commitText();
			
			Assert.assertEquals("Jonnie developed this class. He really did! Really? Yes.", textfield.text);
		}
		
		[Test]
		public function testHTMLText():void {
			var textfield:TextFieldPlus = new TextFieldPlus();
			
			textfield.text = "Jonnie developed this class.";
			textfield.htmlText = "Jonnie developed <em>that</em> class.";
			
			Assert.assertTrue(textfield.html);
			Assert.assertEquals("Jonnie developed that class.", textfield.text);
		}
		
		[Test]
		public function testReplaceText():void {
			var textfield:TextFieldPlus = new TextFieldPlus();
			
			textfield.text = "Jonnie developed this class.";
			textfield.replaceText(7, 16, "wrote");
			
			Assert.assertEquals("Jonnie wrote this class.", textfield.text);
		}
		
		[Test]
		public function testAppendText():void {
			var textfield:TextFieldPlus = new TextFieldPlus();
			
			textfield.text = "Jonnie developed this class.";
			textfield.appendText(" He really did!");
			
			Assert.assertEquals("Jonnie developed this class. He really did!", textfield.text);
			
			textfield.beginText();
			textfield.appendText(" Really?");
			textfield.appendText(" Yes.");
			textfield.commitText();
			
			Assert.assertEquals("Jonnie developed this class. He really did! Really? Yes.", textfield.text);
		}
	}
}