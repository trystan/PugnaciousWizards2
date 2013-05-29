package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import spells.FireJump;
	
	public class PlayScreen implements Screen
	{
		public var player:Player;
		public var world:World;
		public var display:WorldDisplay;
		
		public function PlayScreen(player:Player = null, world:World = null) 
		{
			if (player == null)
				player = new Player(new Point(1, 35));
				
			if (world == null)
				world = new World().addWorldGen(new WorldGen());
			
			this.player = player;
			this.world = world;
			
			world.add(player);
			
			display = new WorldDisplay(player, world);
		}
		
		public function handleInput(keyEvent:KeyboardEvent):void
		{
			var endTurn:Boolean = true;
			
			switch (keyEvent.keyCode)
			{
				case 39: player.moveBy(1, 0); break;
				case 37: player.moveBy(-1, 0); break;
				case 40: player.moveBy(0, 1); break;
				case 38: player.moveBy(0, -1); break;
				case 49: new FireJump().playerCast(player, nextTurn); break;
				default:
					trace(keyEvent.keyCode);
					endTurn = false;
			}
			
			if (endTurn)
				nextTurn();
		}
		
		public function nextTurn():void
		{
			world.update();
			
			if (player.health < 1)
				Main.switchToScreen(new FailScreen(player, world));
			else if (world.playerHasWon)
				Main.switchToScreen(new VictoryScreen(player, world));
		}
		
		public function refresh(terminal:AsciiPanel):void
		{
			display.draw(terminal);
		}
		
		public function animateOneFrame(terminal:AsciiPanel):Boolean 
		{
			return display.animateOneFrame(terminal);
		}
	}
}