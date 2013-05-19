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
		private var screen:PlayScreen = new PlayScreen(player, new World());
			
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
			
			screen.world.addWall(6, 4);
			
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
			
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				terminal.write(screen.world.isWall(x, y) ? "#" : String.fromCharCode(250), x, y);
				
			terminal.write("@", player.position.x, player.position.y);
			terminal.paint();
		}
	}
}