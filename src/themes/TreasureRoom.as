package themes
{
	import flash.geom.Point;
	import spells.*;
	
	public class TreasureRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			if (room.isEndRoom)
				endRoom(room, world);
			else if (Math.random() < Globals.rarePercent)
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
		
		private function addPool(world:World, x:int, y:int):void 
		{
			world.addTile(x + 0, y + 0, Tile.shallow_water);
			world.addTile(x + 1, y + 0, Tile.shallow_water);
			world.addTile(x + 1, y + 1, Tile.shallow_water);
			world.addTile(x + 0, y + 1, Tile.shallow_water);
		}
		
		public function addRoomArchitecture(room:Room, world:World):void
		{
			var r:Number = Math.random();
			
			if (r < 0.1)
			{
				for (var x:int = 0; x < 7; x++)
				for (var y:int = 0; y < 7; y++)
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
				addPool(world, room.worldPosition.x + 1, room.worldPosition.y + 1);
				addPool(world, room.worldPosition.x + 4, room.worldPosition.y + 1);
				addPool(world, room.worldPosition.x + 4, room.worldPosition.y + 4);
				addPool(world, room.worldPosition.x + 1, room.worldPosition.y + 4);
			}
			else if (r < 0.6)
			{
				world.addTile(room.worldPosition.x + 1, room.worldPosition.y + 1, Tile.tree);
				world.addTile(room.worldPosition.x + 5, room.worldPosition.y + 1, Tile.tree);
				world.addTile(room.worldPosition.x + 5, room.worldPosition.y + 5, Tile.tree);
				world.addTile(room.worldPosition.x + 1, room.worldPosition.y + 5, Tile.tree);
			}
		}
	}
}