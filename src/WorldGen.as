package  
{
	public class WorldGen 
	{
		private var rooms:Array;
		
		public function WorldGen()
		{
			addRooms();	
		}
		
		public function apply(world:World):void 
		{
			addCastleFloor(world)
			addCastleWalls(world);
			addCastleDoors(world);
		}
		
		private function addRooms():void 
		{
			rooms = [];
			for (var x:int = 0; x < 9; x++)
			{
				var row:Array = [];
				for (var y:int = 0; y < 9; y++)
					row.push(new Room(x, y));
				rooms.push(row);
			}
		}
		
		public function getRoom(x:int, y:int):Object 
		{
			return rooms[x][y];
		}
		
		private function addCastleFloor(world:World):void
		{
			for (var x:int = 4; x < 77; x++)
			for (var y:int = 4; y < 77; y++)
				world.addTile(x, y, (x + y) % 2 == 1 ? Tile.floor_dark : Tile.floor_light);
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
	}
}