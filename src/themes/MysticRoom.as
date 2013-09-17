package themes
{
	import flash.geom.Point;
	
	public class MysticRoom implements RoomTheme
	{
		public function get name():String { return "Mystic symbol"; }
		
		public function apply(room:Room, world:World):void
		{
			room.allowsVariation = false;
			
			room.forbidMagic = true;
			
			for (var x:int = room.position.x * 8 + 5; x < room.position.x * 8 + 12; x++)
			for (var y:int = room.position.y * 8 + 5; y < room.position.y * 8 + 12; y++)
				setFloor(world, x, y)
		}
		
		private function setFloor(world:World, x:int, y:int):void
		{
			if (world.getTile(x, y, true) == Tile.floor_dark || world.getTile(x, y, true) == Tile.floor_light)
				world.addTile(x, y, ((x+y)%2) == 0 ? Tile.mystic_floor_light : Tile.mystic_floor_dark);
		}
	}
}