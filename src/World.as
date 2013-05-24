package  
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import features.CastleFeature; 
	
	public class World 
	{
		private var player:Player;
		private var tiles:Dictionary = new Dictionary();
		public var items:Array = [];
		public var rooms:Array = [];
		public var effects:Array = [];
		public var animationEffects:Array = [];
		
		public function get playerHasWon():Boolean 
		{
			return player.hasAllEndPieces && player.position.x < 4;
		}
		
		public function addEffect(effect:CastleFeature):void
		{
			effects.push(effect);
		}
		
		public function addAnimationEffect(effect:Object):void
		{
			animationEffects.push(effect);
		}
		
		public function removeAnimationEffect(effect:Object):void
		{
			var index:int = animationEffects.indexOf(effect);
			
			if (index > -1)
				animationEffects.splice(index, 1);
		}
		
		public function add(player:Player):void
		{
			this.player = player;
			
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
		
		public function getItem(x:int, y:int):EndPiece 
		{
			for each (var placedItem:Object in items)
			{
				if (placedItem.x == x && placedItem.y == y)
					return placedItem.item as EndPiece;
			}
			return null;
		}
		
		public function removeItem(x:int, y:int):void 
		{
			var index:int = -1;
			for (var i:int = 0; i < items.length; i++)
			{
				var placedItem:Object = items[i];
				if (placedItem.x == x && placedItem.y == y)
					index = i;
			}
			
			if (index > -1)
				items.splice(index, 1);
		}
		
		public function getRoom(x:int, y:int):Room 
		{
			for each (var room:Room in rooms)
			{
				if (room.contains(x, y))
					return room;
			}
			return null;
		}
		
		public function update():void
		{
			for each (var effect:CastleFeature in effects)
				effect.update();
		}
		
		public function getCreatureAt(x:int, y:int):Player 
		{
			if (player.position.x == x && player.position.y == y)
				return player;
				
			return null;
		}
	}
}