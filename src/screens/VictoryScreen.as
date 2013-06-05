package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import knave.BaseScreen;
	
	public class VictoryScreen extends BaseScreen
	{
		public var player:Player;
		public var world:World;
		
		public function VictoryScreen(player:Player, world:World) 
		{
			this.player = player;
			this.world = world;
			
			bind('enter', function():void { switchTo(new PlayScreen()); } );
		}
		
		public override function draw(terminal:AsciiPanel):void
		{
			terminal.clear();
			terminal.write("You won!", 2, 2);
			terminal.writeCenter("-- press enter to restart --", 78);
		}
	}
}