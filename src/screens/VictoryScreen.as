package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import knave.BaseScreen;
	
	public class VictoryScreen extends BaseScreen
	{
		public var player:Creature;
		public var world:World;
		
		public function VictoryScreen(player:Creature, world:World) 
		{
			this.player = player;
			this.world = world;
			
			bind('enter', function():void { switchTo(new PlayScreen()); } );
			bind('draw', draw);
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			terminal.clear();
			terminal.write("You won!", 2, 2);
			terminal.writeCenter("-- press enter to restart --", 78);
		}
	}
}