package themes
{
	import flash.geom.Point;
	import spells.*;
	
	public class TreasureRoom implements RoomTheme
	{
		public function get name():String { return "Treasure room"; }
		
		public function apply(room:Room, world:World):void
		{
			if (room.isEndRoom)
				endRoom(room, world);
			else if (Math.random() < CurrentGameVariables.rarePercent)
				bigTreasure(room, world);
			else
				normalTreasure(room, world);
			
			addRoomArchitecture(room, world);
		}
		
		private function endRoom(room:Room, world:World):void 
		{
			world.addItem(room.worldPosition.x + 3, room.worldPosition.y + 3, new EndPiece());
			world.addCreature(TreasureFactory.randomWizard(room));
		}
	
		private function normalTreasure(room:Room, world:World):void 
		{
			world.addItem(room.worldPosition.x + 3, room.worldPosition.y + 3, TreasureFactory.random());
		}
		
		private function bigTreasure(room:Room, world:World):void 
		{
			world.addItem(room.worldPosition.x + 2, room.worldPosition.y + 2, TreasureFactory.random());
			world.addItem(room.worldPosition.x + 2, room.worldPosition.y + 4, TreasureFactory.random());
			world.addItem(room.worldPosition.x + 4, room.worldPosition.y + 4, TreasureFactory.random());
			world.addItem(room.worldPosition.x + 4, room.worldPosition.y + 2, TreasureFactory.random());
		}
		
		private function addSquare(world:World, x:int, y:int, tile:Tile):void 
		{
			world.addTile(x + 0, y + 0, tile);
			world.addTile(x + 1, y + 0, tile);
			world.addTile(x + 1, y + 1, tile);
			world.addTile(x + 0, y + 1, tile);
		}
		
		public function addRoomArchitecture(room:Room, world:World):void
		{
			var r:Number = Math.random();
			
			var tile:Tile = Math.random() < 0.5 ? Tile.tree : Tile.shallow_water;
			
			if (Math.random() < 0.1)
				tile = Tile.grass;
			
			if (Math.random() < CurrentGameVariables.rarePercent)
				tile = Tile.golden_statue;
				
			if (r < 0.1)
			{
				for (var x:int = 1; x < 6; x++)
				for (var y:int = 1; y < 6; y++)
					world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, Tile.grass);
			}
			else if (r < 0.3)
			{
				world.addTile(room.worldPosition.x + 0, room.worldPosition.y + 0, Tile.wall);
				world.addTile(room.worldPosition.x + 6, room.worldPosition.y + 0, Tile.wall);
				world.addTile(room.worldPosition.x + 6, room.worldPosition.y + 6, Tile.wall);
				world.addTile(room.worldPosition.x + 0, room.worldPosition.y + 6, Tile.wall);
			}
			else if (r < 0.5)
			{	
				addSquare(world, room.worldPosition.x + 1, room.worldPosition.y + 1, tile);
				addSquare(world, room.worldPosition.x + 4, room.worldPosition.y + 1, tile);
				addSquare(world, room.worldPosition.x + 4, room.worldPosition.y + 4, tile);
				addSquare(world, room.worldPosition.x + 1, room.worldPosition.y + 4, tile);
			}
			else if (r < 0.6)
			{
				world.addTile(room.worldPosition.x + 1, room.worldPosition.y + 1, tile);
				world.addTile(room.worldPosition.x + 5, room.worldPosition.y + 1, tile);
				world.addTile(room.worldPosition.x + 5, room.worldPosition.y + 5, tile);
				world.addTile(room.worldPosition.x + 1, room.worldPosition.y + 5, tile);
			}
			else if (r < 0.7)
			{
				for (x = 1; x < 6; x++)
					world.addTile(room.worldPosition.x + x, room.worldPosition.y + 1, tile);
				for (x = 1; x < 6; x++)
					world.addTile(room.worldPosition.x + x, room.worldPosition.y + 5, tile);
				for (y = 1; y < 6; y++)
					world.addTile(room.worldPosition.x + 1, room.worldPosition.y + y, tile);
				for (y = 1; y < 6; y++)
					world.addTile(room.worldPosition.x + 5, room.worldPosition.y + y, tile);
			}
			else if (r < 0.8)
			{
				world.addTile(room.worldPosition.x + 0, room.worldPosition.y + 0, Tile.wall);
				world.addTile(room.worldPosition.x + 6, room.worldPosition.y + 0, Tile.wall);
				world.addTile(room.worldPosition.x + 6, room.worldPosition.y + 6, Tile.wall);
				world.addTile(room.worldPosition.x + 0, room.worldPosition.y + 6, Tile.wall);
				
				world.addTile(room.worldPosition.x + 1, room.worldPosition.y + 0, Tile.wall);
				world.addTile(room.worldPosition.x + 5, room.worldPosition.y + 0, Tile.wall);
				world.addTile(room.worldPosition.x + 5, room.worldPosition.y + 6, Tile.wall);
				world.addTile(room.worldPosition.x + 1, room.worldPosition.y + 6, Tile.wall);
				
				world.addTile(room.worldPosition.x + 0, room.worldPosition.y + 1, Tile.wall);
				world.addTile(room.worldPosition.x + 6, room.worldPosition.y + 1, Tile.wall);
				world.addTile(room.worldPosition.x + 6, room.worldPosition.y + 5, Tile.wall);
				world.addTile(room.worldPosition.x + 0, room.worldPosition.y + 5, Tile.wall);
			}
			else if (r < 0.9)
			{
				for (x = 0; x < 7; x++)
				for (y = 0; y < 7; y++)
					if (x % 2 == 0 && y % 2 == 0)
						world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, tile);
			}
		}
	}
}