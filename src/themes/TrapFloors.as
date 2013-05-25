package themes
{
	import flash.geom.Point;
	import features.FloorTrap;
	
	public class TrapFloors implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			var tiles:Array = [];
			
			var type:int = (int)(Math.random() * 8);
			
			for (var x:int = 0; x < 7; x++)
			for (var y:int = 0; y < 7; y++)
			{
				switch (type)
				{
					case 0:
						if ((x + y) % 2 == 0)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 1:
						if ((x + y) % 2 == 1)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 2:
						if (x % 2 == 0)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 3:
						if (x % 2 == 1)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 4:
						if (y % 2 == 0)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 5:
						if (y % 2 == 1)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 6:
						if (x == 3 || y == 3)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 7:
						if (x != 3 && y != 3)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
				}
			}
			
			var ticks:int = (int)(Math.random() * 24);
			
			for each (var p:Point in tiles)
			{
				if (world.getTile(p.x, p.y).blocksMovement)
					continue;
				
				world.addBlood(p.x, p.y, 1);
				world.addEffect(new FloorTrap(world, p.x, p.y, ticks));
			}
		}
	}
}