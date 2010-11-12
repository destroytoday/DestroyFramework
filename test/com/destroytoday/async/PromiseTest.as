package com.destroytoday.async
{
	import asunit.framework.TestCase;
	
	import com.destroytoday.constant.PromiseState;
	
	/**
	 * The majority of these tests are from Shaun Smith's event-based Promise class
	 * https://github.com/darscan/robotlegs-extensions-Oil/blob/master/src/org/robotlegs/oil/async/Promise.as
	 * @author Jonnie Hallman
	 */
	public class PromiseTest extends TestCase
	{
		protected var promise:Promise;
		protected var errorListenerHitCount:int;
		protected var progressListenerHitCount:int;
		protected var resultListenerHitCount:int;
		protected var statusListenerHitCount:int;
		
		public function PromiseTest():void
		{
			
		}
		
		override protected function setUp():void
		{
			promise = new Promise();
			
			errorListenerHitCount = 0;
			progressListenerHitCount = 0;
			resultListenerHitCount = 0;
			statusListenerHitCount = 0;
		}
		
		override protected function tearDown():void
		{
			promise = null;
		}

		public function testHandleError():void
		{
			promise.failed.add(supportErrorListener);
			promise.dispatchError(null);
			assertTrue("Error dispatcher should run", errorListenerHitCount > 0);
		}
		
		protected function supportErrorListener(p:Promise):void
		{
			errorListenerHitCount++;
		}
		
		public function testHandleProgress():void
		{
			promise.progressChanged.add(supportProgressListener);
			promise.dispatchProgress(null);
			assertTrue("Progress dispatcher should run", progressListenerHitCount > 0);
		}
		
		protected function supportProgressListener(p:Promise):void
		{
			progressListenerHitCount++;
		}
		
		public function testHandleResult():void
		{
			promise.completed.add(supportResultListener);
			promise.dispatchResult(null);
			assertTrue("Result dispatcher should run", resultListenerHitCount > 0);
		}
		
		protected function supportResultListener(p:Promise):void
		{
			resultListenerHitCount++;
		}
		
		public function testHandleStatus():void
		{
			promise.statusChanged.add(supportStatusListener);
			promise.dispatchError(false);
			promise.statusChanged.add(supportStatusListener); // because listeners are removed upon error
			promise.dispatchResult(true);
			promise.statusChanged.add(supportStatusListener); // because listeners are removed upon result
			promise.cancel();
			
			assertEquals("Status dispatcher should run", 3, statusListenerHitCount);
		}
		
		protected function supportStatusListener(p:Promise):void
		{
			statusListenerHitCount++;
		}
		
		public function testGet_error():void
		{
			promise.dispatchError(0.5);
			assertEquals("Error should be set", 0.5, promise.error);
		}
		
		public function testGet_progress():void
		{
			promise.dispatchProgress(0.5);
			assertEquals("Progress should be set", 0.5, promise.progress);
		}
		
		public function testPromise():void
		{
			assertTrue("promise is Promise", promise is Promise);
		}
		
		public function testGet_result():void
		{
			promise.dispatchResult(0.5);
			assertEquals("Result should be set", 0.5, promise.result);
		}
		
		public function testGet_status():void
		{
			assertEquals("Status should start pending", PromiseState.PENDING, promise.status);
		}
		
		public function testCancel():void
		{
			promise.failed.add(supportErrorListener);
			promise.progressChanged.add(supportProgressListener);
			promise.failed.add(supportResultListener);
			promise.cancel();
			promise.dispatchError(null);
			promise.dispatchProgress(null);
			promise.dispatchResult(null);
			assertTrue("Error dispatcher should NOT have run", errorListenerHitCount == 0);
			assertTrue("Progress dispatcher should NOT have run", progressListenerHitCount == 0);
			assertTrue("Result dispatcher should NOT have run", resultListenerHitCount == 0);
		}
		
		public function testHandleResultProcessor():void
		{
			promise.addResultProcessor(supportResultProcessor1);
			promise.addResultProcessor(supportResultProcessor2);
			promise.completed.add(supportResultProcessorListener);
			promise.dispatchResult(100);
			assertTrue("Result dispatcher should run", resultListenerHitCount > 0);
			assertEquals("Result should be processed", "processed", promise.result.title);
			assertEquals("Result should be processed", "Test100", promise.result.string);
		}
		
		protected function supportResultProcessor1(input:Number):String
		{
			var output:String = "Test" + input;
			return output;
		}
		
		protected function supportResultProcessor2(input:String):Object
		{
			var output:Object = {
				title: "processed",
				string: input
			};
			return output;
		}
		
		protected function supportResultProcessorListener(p:Promise):void
		{
			resultListenerHitCount++;
		}
	}
}