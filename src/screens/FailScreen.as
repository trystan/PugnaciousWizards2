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
			var statuses:Array = [];
			if (player.fireCounter > 0)
				statuses.push("on fire");
			if (player.freezeCounter > 0)
				statuses.push("frozen");
			if (player.bleedingCounter > 0)
				statuses.push("bleeding");
			if (player.blindCounter > 0)
				statuses.push("blind");
			
			switch (player.endPiecesPickedUp)
			{
				case 0: statuses.push("with none of the amulet pieces"); break;
				case 1: statuses.push("with one of the amulet pieces"); break;
				case 2: statuses.push("with two of the amulet pieces"); break;
				case 3: statuses.push("with all three of the amulet pieces"); break;
			}
			
			var status:String = statuses.length == 1 ? statuses[0] 
								: statuses.length == 2 ? statuses[0] + " and " + statuses[1]
								: statuses.join(", ");
				
			terminal.write(player.causeOfDeath, 2, 2);
			terminal.write("You died " + status + ".", 2, 5);
			
			terminal.writeCenter("R.I.P", terminal.getHeightInCharacters() / 2);
			
			terminal.writeCenter("-- press enter to restart --", 78);
		}
	}
}