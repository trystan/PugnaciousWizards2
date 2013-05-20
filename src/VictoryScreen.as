package  
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	public class VictoryScreen extends Sprite implements Screen
	{
		public var player:Player;
		public var world:World;
		public var terminal:AsciiPanel;
		
		public function VictoryScreen(player:Player, world:World) 
		{
			this.player = player;
			this.world = world;
			
			terminal = new AsciiPanel(80, 80);
			terminal.useRasterFont(AsciiPanel.codePage437_8x8, 8, 8);
			addChild(terminal);
			refresh();
		}
		
		public function handleInput(keyEvent:KeyboardEvent):void
		{
			switch (keyEvent.keyCode)
			{
				case 13:
					Main.switchToScreen(new PlayScreen());
					break;
				default:
					trace(keyEvent.keyCode);
					refresh();
			}
		}
		
		public function refresh():void
		{
			terminal.clear();
			terminal.write("You won!", 2, 2);
			terminal.writeCenter("-- press enter to restart --", 78);
			terminal.paint();
		}
	}
}