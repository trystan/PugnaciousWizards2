package themes
{
	import flash.geom.Point;
	import features.FloorTrap;
	
	public class TrapFloors implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			var tiles:Array = [];
			
			var type:int = (int)(Math.random() * 10);
			
			if (Math.random() < Globals.rarePercent)
				type = 99;
			
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
					case 8:
						if (x < 1 || x > 5 || y < 1 || y > 5)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 9:
						if (x > 1 && x < 5 && y > 1 && y < 5)
							tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
					case 99:
						tiles.push(new Point(room.worldPosition.x + x, room.worldPosition.y + y));
						break;
				}
			}
			
			var triggers:Array = [];
			
			for each (var p:Point in tiles)
			{
				if (world.getTile(p.x, p.y).blocksMovement)
					continue;
				
				triggers.push(p);
				world.addBlood(p.x, p.y, 2);
			}
			
			world.addFeature(new FloorTrap(world, triggers));
		}
	}
}