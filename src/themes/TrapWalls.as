package themes
{
	import flash.geom.Point;
	import features.WallTrap;
	import payloads.Payload;
	import payloads.PayloadFactory;
	
	public class TrapWalls implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			var dir:String = "NSWE".charAt((int)(Math.random() * 4));
			
			var tiles:Array = [];
			
			switch (dir)
			{
				case "N":
					for (var nx:int = 0; nx < 7; nx++)
						if (world.isWall(room.worldPosition.x + nx, room.worldPosition.y - 1))
							tiles.push(new Point(room.worldPosition.x + nx, room.worldPosition.y - 1));
					break;
				case "S":
					for (var sx:int = 0; sx < 7; sx++)
						if (world.isWall(room.worldPosition.x + sx, room.worldPosition.y + 7))
							tiles.push(new Point(room.worldPosition.x + sx, room.worldPosition.y + 7));
					break;
				case "W":
					for (var wy:int = 0; wy < 7; wy++)
						if (world.isWall(room.worldPosition.x - 1, room.worldPosition.y + wy))
							tiles.push(new Point(room.worldPosition.x - 1, room.worldPosition.y + wy));
					break;
				case "E":
					for (var ey:int = 0; ey < 7; ey++)
						if (world.isWall(room.worldPosition.x + 7, room.worldPosition.y + ey))
							tiles.push(new Point(room.worldPosition.x + 7, room.worldPosition.y + ey));
					break;
			}
			
			var ticks:int = (int)(Math.random() * 24);
			var payload:Payload = PayloadFactory.random();
			
			world.addEffect(new WallTrap(world, tiles, dir, ticks, payload));
		}
	}
}