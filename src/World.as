package  
{
	import flash.utils.Dictionary;
	
	public class World 
	{
		private var tiles:Dictionary = new Dictionary();
		
		public function add(player:Player):void
		{
			player.world = this;
		}
		
		public function blocksMovement(x:int, y:int):Boolean
		{
			return isOutOfBounds(x, y) || isWall(x, y);
		}
		
		public function addTile(x:int, y:int, tile:Tile):void
		{
			tiles[x + "," + y] = tile;
		}
		
		public function getTile(x:int, y:int):Tile
		{
			var t:Tile = tiles[x + "," + y];
			return t == null ? Tile.floor : t;
		}
		
		public function addWall(x:int, y:int):void 
		{
			addTile(x, y, Tile.wall);
		}
		
		public function addDoor(x:int, y:int):void 
		{
			addTile(x, y, Tile.door_closed);
		}
		
		public function openDoor(x:int, y:int):void
		{
			addTile(x, y, Tile.door_opened);
		}
		
		public function isWall(x:int, y:int):Boolean
		{
			return getTile(x, y) == Tile.wall;
		}
		
		public function isClosedDoor(x:int, y:int):Boolean 
		{
			return getTile(x, y) == Tile.door_closed;
		}
		
		public function isOpenedDoor(x:int, y:int):Boolean 
		{
			return getTile(x, y) == Tile.door_opened;
		}
		
		public function addCastle():void 
		{
			addCastleWalls();
			addCastleDoors();
		}
		
		private function addCastleDoors():void 
		{
			for (var x1:int = 0; x1 < 8; x1++)
			for (var y1:int = 0; y1 < 9; y1++)
				addDoor(x1 * 8 + 12, y1 * 8 + 8);
				
			for (var x2:int = 0; x2 < 9; x2++)
			for (var y2:int = 0; y2 < 8; y2++)
				addDoor(x2 * 8 + 8, y2 * 8 + 12);
				
			addDoor(4, 8 * 4 + 8);
		}
		
		public function addCastleWalls():void
		{
			for (var x1:int = 0; x1 < 9 * 8 + 1; x1++)
			for (var y1:int = 0; y1 < 10; y1++)
				addWall(x1 + 4, y1 * 8 + 4);
				
			for (var x2:int = 0; x2 < 10; x2++)
			for (var y2:int = 0; y2 < 9 * 8 + 1; y2++)
				addWall(x2 * 8 + 4, y2 + 4);
		}
		
		private function isOutOfBounds(x:int, y:int):Boolean 
		{
			return x < 0 || y < 0 || x > 79 || y > 79;
		}
	}
}