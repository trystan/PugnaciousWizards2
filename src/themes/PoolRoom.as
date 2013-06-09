package themes
{
	public class PoolRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			if (Math.random() < Globals.rarePercent)
				fullPool(room, world);
			else
				smallPool(room, world);
		}
		
		private function smallPool(room:Room, world:World):void 
		{
			for (var x:int = room.worldPosition.x + 1; x < room.worldPosition.x + 6; x++)
			for (var y:int = room.worldPosition.y + 1; y < room.worldPosition.y + 6; y++)
				world.addTile(x, y, Tile.shallow_water);
		}
		
		private function fullPool(room:Room, world:World):void 
		{
			for (var x:int = room.worldPosition.x; x < room.worldPosition.x + 7; x++)
			for (var y:int = room.worldPosition.y; y < room.worldPosition.y + 7; y++)
				world.addTile(x, y, Tile.shallow_water);
		}
	}
}