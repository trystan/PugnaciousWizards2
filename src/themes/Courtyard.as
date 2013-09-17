package themes
{
	public class Courtyard implements RoomTheme
	{
		public function get name():String { return "Courtyard"; }
		
		public function apply(room:Room, world:World):void
		{
			if (Math.random() < CurrentGameVariables.rarePercent)
				fullOfTrees(room, world);
			else
				normalCourtyard(room, world);
		}
		
		private function fullOfTrees(room:Room, world:World):void 
		{
			for (var x:int = room.position.x * 8 + 5; x < room.position.x * 8 + 12; x++)
			for (var y:int = room.position.y * 8 + 5; y < room.position.y * 8 + 12; y++)
				world.addTile(x, y, Tile.tree);
		}
		
		private function normalCourtyard(room:Room, world:World):void 
		{
			for (var x:int = room.position.x * 8 + 5; x < room.position.x * 8 + 12; x++)
			for (var y:int = room.position.y * 8 + 5; y < room.position.y * 8 + 12; y++)
				world.addTile(x, y, Tile.grass);
				
			var treeCount:int = Math.random() * 14 + Math.random() * 14 + 1;
			
			while (treeCount-- > 0)
			{
				var tx:int = room.position.x * 8 + 5 + Math.random() * 7;
				var ty:int = room.position.y * 8 + 5 + Math.random() * 7;
				world.addTile(tx, ty, Tile.tree);
			}
		}
	}
}