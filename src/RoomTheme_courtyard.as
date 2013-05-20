package  
{
	public class RoomTheme_courtyard implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			for (var x:int = room.position.x * 8 + 5; x < room.position.x * 8 + 12; x++)
			for (var y:int = room.position.y * 8 + 5; y < room.position.y * 8 + 12; y++)
				world.addTile(x, y, Tile.grass);
				
			var treeCount:int = Math.random() * 9 + 1;
			
			while (treeCount-- > 0)
			{
				var tx:int = room.position.x * 8 + 5 + Math.random() * 7;
				var ty:int = room.position.y * 8 + 5 + Math.random() * 7;
				world.addTile(tx, ty, Tile.tree);
			}
		}
	}
}