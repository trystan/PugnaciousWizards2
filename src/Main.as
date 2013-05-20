package 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.StaticText;
	import flash.text.TextField;
	
	public class Main extends Sprite 
	{
		private static var current:Main;
		
		private var screen:Screen;
			
		public function Main():void 
		{
			if (!runTests())
				return;
			
			current = this;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function runTests():Boolean
		{
			var tests:Tests = new Tests();
			tests.run();
			if (tests.failed)
			{
				var text:TextField = new TextField();
				text.text = tests.message;
				text.width = text.textWidth + 5;
				addChild(text);
			}
			return tests.passed;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			screen = new PlayScreen();
			
			addChild(screen as Sprite);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			screen.handleInput(e);
		}
		
		public static function switchToScreen(newScreen:Screen):void
		{
			current.removeChild(current.screen as Sprite);
			current.screen = newScreen;
			current.addChild(current.screen as Sprite);
			current.screen.refresh();
		}
	}
}