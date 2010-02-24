package {
	import asunit4.ui.FlashBuilderRunnerUI;
	import asunit4.ui.MinimalRunnerUI;
	
	import com.destroytoday.util.WindowUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class DestroyFrameworkTestRunner extends MinimalRunnerUI {
		public function DestroyFrameworkTestRunner() {
			stage.stageWidth = 800.0;
			stage.stageHeight = 600.0;
			
			WindowUtil.center(stage.nativeWindow);

			run(DestroyFrameworkTestSuite);
			
			stage.nativeWindow.activate();
		}
	}
}