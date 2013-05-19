package  
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	public class PlayScreen 
	{
		public var player:Player;
		public var world:World;
		
		public function PlayScreen(player:Player, world:World) 
		{
			this.player = player;
			this.world = world;
			world.add(player);
		}
		
		public function handleInput(keyEvent:KeyboardEvent):void
		{
			switch (keyEvent.keyCode)
			{
				case 39: player.moveBy(1, 0); break;
				case 37: player.moveBy(-1, 0); break;
				case 40: player.moveBy(0, 1); break;
				case 38: player.moveBy(0, -1); break;
				default:
					trace(keyEvent.keyCode);
			}
		}
	}
}