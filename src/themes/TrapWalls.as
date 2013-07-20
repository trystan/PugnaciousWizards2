package themes
{
	import features.CastleFeature;
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
						if (world.getTile(room.worldPosition.x + nx, room.worldPosition.y - 1) == Tile.wall)
							tiles.push(new Point(room.worldPosition.x + nx, room.worldPosition.y - 1));
					break;
				case "S":
					for (var sx:int = 0; sx < 7; sx++)
						if (world.getTile(room.worldPosition.x + sx, room.worldPosition.y + 7) == Tile.wall)
							tiles.push(new Point(room.worldPosition.x + sx, room.worldPosition.y + 7));
					break;
				case "W":
					for (var wy:int = 0; wy < 7; wy++)
						if (world.getTile(room.worldPosition.x - 1, room.worldPosition.y + wy) == Tile.wall)
							tiles.push(new Point(room.worldPosition.x - 1, room.worldPosition.y + wy));
					break;
				case "E":
					for (var ey:int = 0; ey < 7; ey++)
						if (world.getTile(room.worldPosition.x + 7, room.worldPosition.y + ey) == Tile.wall)
							tiles.push(new Point(room.worldPosition.x + 7, room.worldPosition.y + ey));
					break;
			}
			
			var ticks:int = (int)(Math.random() * 24);
			var payload:Payload = PayloadFactory.random();
			var howOften:int = Math.random() < Globals.rarePercent ? 1 : 3;
			
			var f:CastleFeature = new WallTrap(world, tiles, dir, ticks, payload, howOften);
			room.roomFeatures.push(f);
			world.addFeature(f);
		}
	}
}