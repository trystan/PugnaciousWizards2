package  
{
	public class WorldGen 
	{
		private var rooms:Array;
		
		public function WorldGen()
		{
			addRooms();
			connectRoomsAsPerfectMaze();
		}
		
		public function apply(world:World):void 
		{
			addTrees(world);
			addCastleFloor(world)
			addCastleWalls(world);
			addCastleDoors(world);
			addCastleRooms(world);
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
		
		private function connectRoomsAsPerfectMaze():void 
		{
			var connected:Array = [getRoom(0, 0)];
			var frontier:Array = [getRoom(1, 0), getRoom(0, 1)];
			
			var tries:int = 0;
			
			while (frontier.length > 0 && tries++ < 1000)
			{
				var here:Room = frontier[Math.floor(Math.random() * frontier.length)];
				
				if (connected.indexOf(here) >= 0)
					continue;
				
				connected.push(here);
				
				var neighbors:Array = [];
				
				for each (var other:Room in connected)
				{
					if (Math.abs(other.position.x - here.position.x) + Math.abs(other.position.y - here.position.y) == 1)
						neighbors.push(other);
				}
				
				if (neighbors.length == 0)
					continue;
				
				var next:Room = neighbors[Math.floor(Math.random() * neighbors.length)];
				
				if (here.position.x < next.position.x)
				{
					here.isConnectedEast = true;
					next.isConnectedWest = true;
				}
				else if (here.position.x > next.position.x)
				{
					here.isConnectedWest = true;
					next.isConnectedEast = true;
				}
				else if (here.position.y < next.position.y)
				{
					here.isConnectedSouth = true;
					next.isConnectedNorth = true;
				}
				else if (here.position.y > next.position.y)
				{
					here.isConnectedNorth = true;
					next.isConnectedSouth = true;
				}
				
				if (here.position.x > 0 && frontier.indexOf(getRoom(here.position.x - 1, here.position.y)) == -1)
					frontier.push(getRoom(here.position.x - 1, here.position.y));
				if (here.position.y > 0 && frontier.indexOf(getRoom(here.position.x, here.position.y - 1)) == -1)
					frontier.push(getRoom(here.position.x, here.position.y - 1));
				if (here.position.x < 8 && frontier.indexOf(getRoom(here.position.x + 1, here.position.y)) == -1)
					frontier.push(getRoom(here.position.x + 1, here.position.y));
				if (here.position.y < 8 && frontier.indexOf(getRoom(here.position.x, here.position.y + 1)) == -1)
					frontier.push(getRoom(here.position.x, here.position.y + 1));
			}
		}
		
		public function getRoom(x:int, y:int):Room 
		{
			return rooms[x][y];
		}
		
		
		private function addTrees(world:World):void 
		{
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 15; y++)
			{
				if (Math.random() < 0.33)
					world.addTile(x, y, Tile.tree);
			}
			
			for (var x2:int = 0; x2 < 80; x2++)
			for (var y2:int = 65; y2 < 80; y2++)
			{
				if (Math.random() < 0.33)
					world.addTile(x2, y2, Tile.tree);
			}
			
			for (var x3:int = 10; x3 < 80; x3++)
			for (var y3:int = 0; y3 < 80; y3++)
			{
				if (Math.random() < 0.80)
					world.addTile(x3, y3, Tile.tree);
			}
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
			for (var x:int = 0; x < 9; x++)
			for (var y:int = 0; y < 9; y++)
			{
				var room:Room = getRoom(x, y);
				
				if (room.isConnectedEast)
					world.addDoor(room.position.x * 8 + 12, room.position.y * 8 + 8);
				if (room.isConnectedWest)
					world.addDoor(room.position.x * 8 + 4, room.position.y * 8 + 8);
				if (room.isConnectedSouth)
					world.addDoor(room.position.x * 8 + 8, room.position.y * 8 + 12);
				if (room.isConnectedNorth)
					world.addDoor(room.position.x * 8 + 8, room.position.y * 8 + 4);
			}
			
			world.addDoor(4, 8 * 4 + 8);
		}
		
		private function addCastleRooms(world:World):void 
		{
			for (var x:int = 0; x < 9; x++)
			for (var y:int = 0; y < 9; y++)
				getRoom(x, y).apply(world);
		}
	}
}