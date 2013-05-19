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
		private var player:Player = new Player(new Point(5, 5));
		private var terminal:AsciiPanel = new AsciiPanel(80, 80);
		private var screen:PlayScreen = new PlayScreen(player);
			
		public function Main():void 
		{
			if (!runTests())
				return;
				
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
			
			terminal.useRasterFont(AsciiPanel.codePage437_8x8, 8, 8);
			addChild(terminal);
			
			redraw();
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			screen.handleInput(e);
			
			redraw();
		}
		
		private function redraw():void 
		{
			terminal.clear();
			terminal.write("@", player.position.x, player.position.y);
			terminal.paint();
		}
	}
}