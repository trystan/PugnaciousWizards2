package  
{
	import flash.utils.Dictionary;
	
	public class World 
	{
		private var tiles:Dictionary = new Dictionary();
		public var items:Array = [];
		
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
			if (t != null)
				return t;
				
			return Tile.grass;
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
		
		private function isOutOfBounds(x:int, y:int):Boolean 
		{
			return x < 0 || y < 0 || x > 79 || y > 79;
		}
		
		public function addWorldGen(gen:WorldGen):World
		{
			gen.apply(this);
			return this;
		}
		
		public function addItem(ix:int, iy:int, thing:EndPiece):void 
		{
			items.push({ x:ix, y:iy, item:thing });
		}
	}
}