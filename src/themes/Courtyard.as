package themes
{
	public class Courtyard implements RoomTheme
	{
		public function get name():String { return "Courtyard"; }
		
		public function apply(room:Room, world:World):void
		{
			if (Math.random() < CurrentGameVariables.rarePercent + CurrentGameVariables.treeChance / 5)
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
				world.addTile(x, y, Math.random() < CurrentGameVariables.treeChance ? Tile.tree : Tile.grass);
		}
	}
}