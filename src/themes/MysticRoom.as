package themes
{
	import flash.geom.Point;
	
	public class MysticRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			room.forbidMagic = true;
			
			for (var x:int = room.position.x * 8 + 5; x < room.position.x * 8 + 12; x++)
			for (var y:int = room.position.y * 8 + 5; y < room.position.y * 8 + 12; y++)
				world.addTile(x, y, ((x+y)%2) == 0 ? Tile.mystic_floor_light : Tile.mystic_floor_dark);
		}
	}
}