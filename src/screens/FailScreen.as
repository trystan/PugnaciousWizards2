package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	
	public class FailScreen implements Screen
	{
		public var player:Player;
		public var world:World;
		
		public function FailScreen(player:Player, world:World) 
		{
			this.player = player;
			this.world = world;
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
			}
		}
		
		public function refresh(terminal:AsciiPanel):void
		{
			terminal.clear();
			terminal.write("You died!", 2, 2);
			terminal.writeCenter("-- press enter to restart --", 78);
		}
		
		public function animateOneFrame(terminal:AsciiPanel):Boolean 
		{
			return false;
		}
	}
}