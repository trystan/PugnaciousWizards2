package  
{
	import flash.geom.Orientation3D;
	import flash.geom.Point;
	import payloads.Fire;
	import payloads.Ice;
	import payloads.Payload;
	import payloads.Poison;
	import spells.BloodBurn;
	import spells.BoneSplode;
	import spells.FireJump;
	import spells.HealAndWeaken;
	import spells.Inferno;
	import spells.MagicMissile;
	import themes.TreasureFactory;
	
	public class WorldGen 
	{
		private var rooms:Array;
		private var skipRooms:Boolean;
		
		public function WorldGen(skipRooms:Boolean = false)
		{
			this.skipRooms = skipRooms;
			
			addRooms();
			connectRoomsAsPerfectMaze();
			connectExtraRooms();
			addRoomDistances();
			
			getRoom(0, 4).isConnectedWest = true;
			
			addItems();
		}
		
		private function addRoomDistances():void 
		{
			addRoomDistance(0, 4, 1);
		}
		
		private function addRoomDistance(x:int, y:int, dist:int):void 
		{
			var room:Room = rooms[x][y];
			
			if (room.distance > 0 && room.distance <= dist)
				return;
			
			room.distance = dist;
			
			if (room.isConnectedWest)
				addRoomDistance(x - 1, y, dist + 1);
			if (room.isConnectedEast)
				addRoomDistance(x + 1, y, dist + 1);
			if (room.isConnectedNorth)
				addRoomDistance(x, y - 1, dist + 1);
			if (room.isConnectedSouth)
				addRoomDistance(x, y + 1, dist + 1);
		}
		
		private function addItems():void 
		{
			var candidates:Array = [];
			
			for (var x:int = 0; x < 9; x++)
			for (var y:int = 0; y < 9; y++)
			{
				var room:Room = getRoom(x, y);
				if (room.isDeadEnd)
					candidates.push(room);
			}
			
			if (candidates.length >= 3)
			{
				for (var i:int = 0; i < 3; i++)
				{
					var index:int = Math.floor(Math.random() * candidates.length);
					var endRoom:Room = candidates[index];
					candidates.splice(index, 1);
					endRoom.isEndRoom = true;
				}
			}
		}
		
		public function apply(world:World):void 
		{
			if (!skipRooms)
				addTrees(world);
				
			addCastleFloor(world)
			addCastleWalls(world);
			addCastleDoors(world);
			addCastleBars(world);
			
			if (!skipRooms)
				addCastleRooms(world);
				
			var roomList:Array = [];
			
			for each (var list:Array in rooms)
			for each (var room:Room in list)
				roomList.push(room);
			
			world.rooms = roomList;
			
			addThemedAreas(world);
			
			world.addItem(2, 33, new Scroll(new FireJump()));
			world.addItem(3, 35, new Scroll(new MagicMissile()));
			world.addItem(2, 37, new Scroll(new HealAndWeaken()));
			
			addGold(world);
		}
		
		private function addThemedAreas(world:World):void
		{
			var alreadyThemed:Array = [];
			var startRooms:Array = [];
			for each (var c:Creature in world.creatures)
			{
				if (c is EnemyWizard)
					startRooms.push({ room: world.getRoom(c.position.x, c.position.y), payload: (c as EnemyWizard).aura });
			}
			
			for each (var start:Object in startRooms)
			{
				var rooms:Array = [start.room as Room];
				var payload:Payload = start.payload as Payload;
				var count:int = 0;
				while (count++ < 4 && rooms.length > 0)
				{
					var room:Room = rooms.shift();
					if (alreadyThemed.indexOf(room) > -1 || room == null)
					{
						count--;
						continue;
					}
					
					room.retheme(world, payload);
					alreadyThemed.push(room);
					
					if (room.isConnectedNorth)
						rooms.push(getRoom(room.position.x, room.position.y - 1));
					if (room.isConnectedSouth)
						rooms.push(getRoom(room.position.x, room.position.y + 1));
					if (room.isConnectedWest && room.position.x > 0) // the front door
						rooms.push(getRoom(room.position.x - 1, room.position.y));
					if (room.isConnectedEast)
						rooms.push(getRoom(room.position.x + 1, room.position.y));
				}
			}
		}
		
		private function addGold(world:World):void
		{
			var added:int = 0;
			while (added < 50)
			{
				var x:int = Math.random() * 7 * 8 + 5;
				var y:int = Math.random() * 7 * 8 + 5;
				
				if (world.getTile(x, y).blocksMovement)
					continue;
					
				if (world.getCreature(x, y) != null)
					continue;
					
				if (world.getItem(x, y) != null)
					continue;
					
				world.addItem(x, y, new Gold());
				added++;
			}
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
		
		private function connectExtraRooms():void 
		{
			var deadEnds:Array = [];
			for (var x:int = 0; x < 9; x++)
			for (var y:int = 0; y < 9; y++)
			{
				var room:Room = getRoom(x, y);
				if (room.isDeadEnd)
					deadEnds.push(room);
			}
			
			var removedCount:int = 0;
			while (deadEnds.length > 1 && removedCount < 3 + 6 + 6)
			{
				var i:int = Math.random() * deadEnds.length;
				deadEnds.splice(i, 1);
				removedCount++;
			}
			
			while (deadEnds.length > 0)
			{
				i = Math.random() * deadEnds.length;
				room = deadEnds.splice(i, 1)[0];
				x = room.position.x;
				y = room.position.y;
				
				while (room.isDeadEnd)
				{
					if (x > 0 && Math.random() < 0.25)
					{
						room.isConnectedWest = true;
						getRoom(x - 1, y).isConnectedEast = true;
					}
					
					if (x < 8 && Math.random() < 0.25)
					{
						room.isConnectedEast = true;
						getRoom(x + 1, y).isConnectedWest = true;
					}
					
					if (y > 0 && Math.random() < 0.25)
					{
						room.isConnectedNorth = true;
						getRoom(x, y - 1).isConnectedSouth = true;
					}
					
					if (y < 8 && Math.random() < 0.25)
					{
						room.isConnectedSouth = true;
						getRoom(x, y + 1).isConnectedNorth = true;
					}
				}
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
				world.addTile(x1 + 4, y1 * 8 + 4, Tile.wall);
				
			for (var x2:int = 0; x2 < 10; x2++)
			for (var y2:int = 0; y2 < 9 * 8 + 1; y2++)
				world.addTile(x2 * 8 + 4, y2 + 4, Tile.wall);
		}
		
		private function getDoorTile():Tile
		{
			return Math.random() < 0.25 ? Tile.stone_door_closed : Tile.wood_door_closed;
		}
		
		private function addCastleDoors(world:World):void 
		{
			for (var x:int = 0; x < 9; x++)
			for (var y:int = 0; y < 9; y++)
			{
				var room:Room = getRoom(x, y);
				
				if (room.isConnectedWest)
					world.addTile(room.position.x * 8 + 4, room.position.y * 8 + 8, getDoorTile());
				if (room.isConnectedNorth)
					world.addTile(room.position.x * 8 + 8, room.position.y * 8 + 4, getDoorTile());
			}
			
			world.addTile(4, 8 * 4 + 8, Tile.wood_door_closed);
		}
		
		private function addCastleBars(world:World):void 
		{
			var barChance:Number = 1.0 / 14.0;
			
			for (var x:int = 0; x < 8; x++)
			for (var y:int = 0; y < 8; y++)
			{
				var room:Room = getRoom(x, y);

				if (Math.random() < barChance)
				{
					world.addTile(room.position.x * 8 + 12, room.position.y * 8 + 6, Tile.bars_v);
					world.addTile(room.position.x * 8 + 12, room.position.y * 8 + 10, Tile.bars_v);
				}
				if (Math.random() < barChance)
				{
					world.addTile(room.position.x * 8 + 6, room.position.y * 8 + 12, Tile.bars_h);
					world.addTile(room.position.x * 8 + 10, room.position.y * 8 + 12, Tile.bars_h);
				}
			}
		}
		
		private function addCastleRooms(world:World):void 
		{
			var roomList:Array = [];
			
			for (var x:int = 0; x < 9; x++)
			for (var y:int = 0; y < 9; y++)
				roomList.push(getRoom(x, y));
				
			while (roomList.length > 0)
			{
				var i:int = (int)(Math.random() * roomList.length);
				
				roomList.splice(i, 1)[0].apply(world);
			}
		}
	}
}