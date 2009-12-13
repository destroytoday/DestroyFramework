package com.destroytoday.util {
	import com.destroytoday.text.TextFieldPlus;
	
	import mx.core.UIComponent;
	
	import org.flexunit.Assert;
	import org.fluint.uiImpersonation.UIImpersonator;
	
	public class TextFieldPlusTestCase {
		public function TextFieldPlusTestCase() {
		}
		
		[Test]
		public function testText():void {
			var textfield:TextFieldPlus = new TextFieldPlus();
			
			textfield.text = "Jonnie developed this class.";
			
			Assert.assertEquals("Jonnie developed this class.", textfield.text);
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
	}
}