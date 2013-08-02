package  
{
	import animations.Animation;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import features.CastleFeature; 
	import payloads.Payload;
	
	public class World 
	{
		public var player:Creature;
		private var tiles:Array = [];
		private var fogAmount:Dictionary = new Dictionary();
		public var creatures:Array = [];
		public var items:Array = [];
		public var rooms:Array = [];
		public var featureList:Array = [];
		public var animationEffects:Array = [];
		private var blood:Array = []
		
		public function get playerHasWon():Boolean 
		{
			return player.hasAllEndPieces && player.position.x < 4;
		}
		
		public function World()
		{
			tiles = grid(Tile.dirt);
			blood = grid(0);
		}
		
		private function grid(defaultValue:Object):Array
		{
			var g:Array = [];
			for (var x:int = 0; x < 80; x++)
			{
				var row:Array = [];
				for (var y:int = 0; y < 80; y++)
					row.push(defaultValue);
				g.push(row);
			}
			return g;
		}
		
		public function addFeature(feature:CastleFeature):void
		{
			featureList.push(feature);
		}
		
		public function removeFeature(feature:CastleFeature):void 
		{
			var index:int = featureList.indexOf(feature);
			if (index > -1)
				featureList.splice(index, 1);
		}
		
		public function addAnimationEffect(effect:Animation):void
		{
			animationEffects.push(effect);
		}
		
		public function removeAnimationEffect(effect:Animation):void
		{
			var index:int = animationEffects.indexOf(effect);
			if (index > -1)
				animationEffects.splice(index, 1);
		}
		
		public function addTile(x:int, y:int, tile:Tile):void
		{
			if (isOutOfBounds(x, y))
				return;
				
			tiles[x][y] = tile;
		}
		
		public function getTile(x:int, y:int, ignoreFog:Boolean = false):Tile
		{
			if (isOutOfBounds(x, y))
				return Tile.out_of_bounds;
				
			if (!ignoreFog) 
			{
				var fog:Object = fogAmount[x + "," + y];
				if (fog != null && fog.amount > 3)
					return Tile.denseFogFor(fog.payload);
				if (fog != null && fog.amount > 0)
					return Tile.sparceFogFor(fog.payload);
			}
			
			var t:Tile = tiles[x][y];
			if (t != null)
				return t;
				
			return Tile.grass;
		}
		
		public function openDoor(x:int, y:int):void
		{
			addTile(x, y, Tile.door_opened);
		}
		
		public function isClosedDoor(x:int, y:int):Boolean 
		{
			return getTile(x, y) == Tile.door_closed || getTile(x, y) == Tile.door_closed_fire;
		}
		
		public function isOpenedDoor(x:int, y:int):Boolean 
		{
			return getTile(x, y) == Tile.door_opened || getTile(x, y) == Tile.door_opened_fire;
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
		
		public function getRoom(x:int, y:int):Room 
		{
			for each (var room:Room in rooms)
			{
				if (room.contains(x, y))
					return room;
			}
			return null;
		}
		
		public function addItem(x:int, y:int, item:Item):void 
		{
			items.push({ x:x, y:y, item:item });
		}
		
		public function removeItem(item:Item):Point
		{
			var index:int = -1;
			var pos:Point = null;
			for (var i:int = 0; i < items.length; i++)
			{
				var placedItem:Object = items[i];
				if (placedItem.item == item)
				{
					index = i;
					pos = new Point(placedItem.x, placedItem.y);
				}
			}
			
			if (index > -1)
				items.splice(index, 1);
				
			return pos;
		}
		
		public function removeItemAt(x:int, y:int):void 
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
		
		public function getItem(x:int, y:int):Item 
		{
			for each (var placedItem:Object in items)
			{
				if (placedItem.x == x && placedItem.y == y)
					return placedItem.item as Item;
			}
			return null;
		}
				
		public function getItems(x:int, y:int):Array 
		{
			var list:Array = [];
			for each (var placedItem:Object in items)
			{
				if (placedItem.x == x && placedItem.y == y)
					list.push(placedItem.item as Item);
			}
			return list;
		}
		
		public function addCreature(creature:Creature):void
		{
			if (creature is Hero || creature is Player)
				this.player = creature;
			
			creatures.push(creature);
			creature.world = this;
		}
		
		public function removeCreature(creature:Creature):void 
		{
			var index:int = creatures.indexOf(creature);
			if (index > -1)
				creatures.splice(index, 1);
		}
		
		public function getCreature(x:int, y:int):Creature 
		{
			for each (var creature:Creature in creatures)
			{
				if (creature.position.x == x && creature.position.y == y && creature.health > 0)
					return creature;
			}
			return null;
		}
		
		public function addBlood(x:int, y:int, amount:int = 1):void
		{
			if (amount < 1) {
				addBlood1(x, y, amount);
				return;
			}
			
			addBlood1(x, y);
			for (var i:int = 1; i < amount; i++)
				addBlood1(x + (int)(Math.random() * 3) - 1, y + (int)(Math.random() * 3) - 1);
		}
		
		private function addBlood1(x:int, y:int, amount:int = 1):void
		{
			blood[x + "," + y] = Math.min(Math.max(0, getBlood(x, y) + amount), 9);
		}
		
		public function getBlood(x:int, y:int):int
		{
			if (blood[x + "," + y] > 0)
				return blood[x + "," + y];
			else
				return 0;
		}
		
		public function updateCreatures():void
		{
			for each (var creature:Creature in creatures.slice())
				creature.update();
		}
		
		public function updateFeatures():void
		{
			for each (var feature:CastleFeature in featureList)
				feature.update();
			
			for each (var placedItem:Object in items)
				placedItem.item.update();
				
			disipateFog();
		}
		
		public function animate():void 
		{
			var nextAnimations:Array = [];
			for each (var animation:Animation in animationEffects)
			{
				animation.update();
				if (!animation.done)
					nextAnimations.push(animation);
			}
			animationEffects = nextAnimations;
		}
		
		public function addFog(x:int, y:int, amount:int, payload:Payload):void 
		{
			var key:String = x + "," + y;
			
			if (fogAmount[key] == null)
				fogAmount[key] = new Fog(amount, payload);
		}
		
		public function disipateFog():void
		{
			var newFog:Dictionary = new Dictionary();
			
			for (var key:String in fogAmount)
			{
				var fog:Fog = fogAmount[key];
				var amount:int = fog.amount - 1;
				
				if (amount < 1)
					continue;
					
				var x:int = key.split(",")[0];
				var y:int = key.split(",")[1];
				
				for each (var offsets:Array in [[ -1, 0], [1, 0], [0, -1], [0, 1]])
				{
					if (Math.random() < 0.25)
						continue;
						
					if (amount < 3 || getTile(x + offsets[0], y + offsets[1]).blocksArrows)
						continue;
						
					var key2:String = (x + offsets[0]) + "," + (y + offsets[1]);
					var diff:int = fogAmount[key2] == null ? amount : amount - fogAmount[key2].amount;
					
					if (diff < 1)
						continue;
						
					amount -= diff / 2;
					
					
					if (newFog[key2] == null)
						newFog[key2] = new Fog(diff / 2, fog.payload);
					else
						newFog[key2].amount = newFog[key2].amount + diff / 2;
				}
				
				if (amount > 0)
					newFog[key] = new Fog(amount, fog.payload);
			}
			
			fogAmount = newFog;
			
			for (key in fogAmount)
			{
				x = key.split(",")[0];
				y = key.split(",")[1];
				newFog[key].payload.hitTile(this, x, y);
			}
		}
	}
}

class Fog
{
	public var amount:int;
	public var payload:payloads.Payload;
	
	public function Fog(amount:int, payload:payloads.Payload)
	{
		this.amount = amount;
		this.payload = payload;
	}
}