package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import knave.BaseScreen;
	import knave.RL;
	
	public class FailScreen extends BaseScreen
	{
		public var player:Player;
		public var world:World;
		
		public function FailScreen(player:Player, world:World) 
		{
			this.player = player;
			this.world = world;
			
			bind('enter', function():void { switchTo(new PlayScreen()); } );
			bind('draw', draw);
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			terminal.clear();
			terminal.write("You died!", 2, 2);
			terminal.writeCenter("-- press enter to restart --", 78);
		}
	}
}