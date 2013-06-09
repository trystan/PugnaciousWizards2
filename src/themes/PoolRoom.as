package themes
{
	public class PoolRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			for (var x:int = room.worldPosition.x + 1; x < room.worldPosition.x + 6; x++)
			for (var y:int = room.worldPosition.y + 1; y < room.worldPosition.y + 6; y++)
				world.addTile(x, y, Tile.shallow_water);
		}
	}
}