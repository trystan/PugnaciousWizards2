package  
{
	public class RoomTheme_courtyard implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			for (var x:int = room.position.x * 8 + 5; x < room.position.x * 8 + 12; x++)
			for (var y:int = room.position.y * 8 + 5; y < room.position.y * 8 + 12; y++)
				world.addTile(x, y, Tile.grass);
		}
	}
}