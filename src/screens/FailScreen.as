package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	public class FailScreen extends Sprite implements Screen
	{
		public var player:Player;
		public var world:World;
		public var terminal:AsciiPanel;
		
		public function FailScreen(player:Player, world:World) 
		{
			this.player = player;
			this.world = world;
			
			terminal = new AsciiPanel(100, 80);
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
			terminal.write("You died!", 2, 2);
			terminal.writeCenter("-- press enter to restart --", 78);
			terminal.paint();
		}
		
		public function animateOneFrame():void 
		{
		}
	}
}