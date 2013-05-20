package  
{
	public class WorldGen 
	{
		public function apply(world:World):void 
		{
			addCastleWalls(world);
			addCastleDoors(world);
		}
		
		private function addCastleDoors(world:World):void 
		{
			for (var x1:int = 0; x1 < 8; x1++)
			for (var y1:int = 0; y1 < 9; y1++)
				world.addDoor(x1 * 8 + 12, y1 * 8 + 8);
				
			for (var x2:int = 0; x2 < 9; x2++)
			for (var y2:int = 0; y2 < 8; y2++)
				world.addDoor(x2 * 8 + 8, y2 * 8 + 12);
				
			world.addDoor(4, 8 * 4 + 8);
		}
		
		public function addCastleWalls(world:World):void
		{
			for (var x1:int = 0; x1 < 9 * 8 + 1; x1++)
			for (var y1:int = 0; y1 < 10; y1++)
				world.addWall(x1 + 4, y1 * 8 + 4);
				
			for (var x2:int = 0; x2 < 10; x2++)
			for (var y2:int = 0; y2 < 9 * 8 + 1; y2++)
				world.addWall(x2 * 8 + 4, y2 + 4);
		}
	}
}