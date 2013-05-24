package  
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	public class PlayScreen extends Sprite implements Screen
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
			addChild(display);
			refresh();
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
				default:
					trace(keyEvent.keyCode);
					endTurn = false;
			}
			
			if (endTurn)
				world.update();
			
			refresh();
			
			if (world.playerHasWon)
				Main.switchToScreen(new VictoryScreen(player, world));
		}
		
		public function refresh():void
		{
			display.draw();
		}
		
		public function handleAnimation(animation:Arrow):void 
		{
			display.handleAnimation(animation);
		}
	}
}