package  
{
	import flash.geom.Point;
	public class RoomTheme_trapWalls implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			var dir:String = "NSWE".charAt((int)(Math.random() * 4));
			
			var tiles:Array = [];
			
			switch (dir)
			{
				case "N":
					for (var nx:int = 0; nx < 7; nx++)
						tiles.push(new Point(room.worldPosition.x + nx, room.worldPosition.y));
					break;
				case "S":
					for (var sx:int = 0; sx < 7; sx++)
						tiles.push(new Point(room.worldPosition.x + sx, room.worldPosition.y + 6));
					break;
				case "W":
					for (var wy:int = 0; wy < 7; wy++)
						tiles.push(new Point(room.worldPosition.x, room.worldPosition.y + wy));
					break;
				case "S":
					for (var ey:int = 0; ey < 7; ey++)
						tiles.push(new Point(room.worldPosition.x + 6, room.worldPosition.y + ey));
					break;
			}
			
			var ticks:int = (int)(Math.random() * 24);
			
			for each (var p:Point in tiles)
				world.addEffect(new WallTrap(world, p.x, p.y, dir, ticks));
		}
	}
}