package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import knave.BaseScreen;
	import knave.RL;
	
	public class FailScreen extends BaseScreen
	{
		public var player:Creature;
		public var world:World;
		
		public function FailScreen(player:Creature, world:World) 
		{
			this.player = player;
			this.world = world;
			
			bind('enter', function():void { switchTo(new PlayScreen()); } );
			bind('draw', draw);
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			//terminal.clear();
			terminal.writeCenter("You have died.", 2);
			terminal.writeCenter(player.causeOfDeath, 4);
			terminal.writeCenter("-- press enter to restart --", 78);
		}
	}
}