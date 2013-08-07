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
		private var tileGrid:Array;
		private var bloodGrid:Array;
		private var fogGrid:Array;
		private var fogPoints:Array = [];
		public var creatures:Array = [];
		public var items:Array = [];
		public var rooms:Array = [];
		public var featureList:Array = [];
		public var animationList:Array = [];
		
		public function get playerHasWon():Boolean 
		{
			return player.hasAllEndPieces && player.position.x < 4;
		}
		
		public function World()
		{
			tileGrid = grid(Tile.grass);
			bloodGrid = grid(0);
			fogGrid = grid(null);
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
		
		public function removeFeatureAt(x:int, y:int):void 
		{
			var toRemove:Array = [];
			for each (var feature:CastleFeature in featureList)
			{
				if (feature.contains(x,y))
					toRemove.push(feature);
			}
			for each (feature in toRemove)
				removeFeature(feature);
		}
		
		public function addAnimationEffect(effect:Animation):void
		{
			animationList.push(effect);
		}
		
		public function removeAnimationEffect(effect:Animation):void
		{
			var index:int = animationList.indexOf(effect);
			if (index > -1)
				animationList.splice(index, 1);
		}
		
		public function addTile(x:int, y:int, tile:Tile):void
		{
			if (isOutOfBounds(x, y))
				return;
				
			tileGrid[x][y] = tile;
		}
		
		public function getTile(x:int, y:int, ignoreFog:Boolean = false):Tile
		{
			if (isOutOfBounds(x, y))
				return Tile.out_of_bounds;
				
			if (!ignoreFog) 
			{
				var fog:Fog = fogGrid[x][y];
				if (fog != null && fog.amount > 0)
					return Tile.fogFor(fog.payload);
			}
			
			return tileGrid[x][y];
		}
		
		public function openDoor(x:int, y:int):void
		{
			switch (getTile(x, y, true))
			{
				case Tile.stone_door_closed:
					addTile(x, y, Tile.stone_door_opened);
					break;
				case Tile.wood_door_closed:
					addTile(x, y, Tile.wood_door_opened);
					break;
				case Tile.door_closed_fire:
					addTile(x, y, Tile.door_opened_fire);
					break;
			}
		}
		
		public function isClosedDoor(x:int, y:int):Boolean 
		{
			var tile:Tile = getTile(x, y, true);
			return tile == Tile.stone_door_closed
			    || tile == Tile.wood_door_closed
			    || tile == Tile.door_closed_fire;
		}
		
		public function isOpenedDoor(x:int, y:int):Boolean 
		{
			var tile:Tile = getTile(x, y, true);
			return tile == Tile.stone_door_opened 
			    || tile == Tile.wood_door_opened 
			    || tile == Tile.door_opened_fire;
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
			items.push(new ItemInWorld(x, y, item));
		}
		
		public function removeItem(item:Item):Point
		{
			var index:int = -1;
			var pos:Point = null;
			for (var i:int = 0; i < items.length; i++)
			{
				var placedItem:ItemInWorld = items[i];
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
		
		public function removeItemsAt(x:int, y:int):void 
		{
			var indices:Array = [];
			for (var i:int = 0; i < items.length; i++)
			{
				var placedItem:ItemInWorld = items[i];
				if (placedItem.x == x && placedItem.y == y)
					indices.push(i);
			}
			
			for each (var index:int in indices)
				items.splice(index, 1);
		}
		
		public function getItem(x:int, y:int):Item 
		{
			for each (var placedItem:ItemInWorld in items)
			{
				if (placedItem.x == x && placedItem.y == y)
					return placedItem.item;
			}
			return null;
		}
				
		public function getItems(x:int, y:int):Array 
		{
			var list:Array = [];
			for each (var placedItem:ItemInWorld in items)
			{
				if (placedItem.x == x && placedItem.y == y)
					list.push(placedItem.item);
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
		
		public function removeCreatureAt(x:int, y:int):void 
		{
			var toRemove:Array = [];
			for each (var creature:Creature in creatures)
			{
				if (creature.position.x == x && creature.position.y == y && creature.health > 0)
					toRemove.push(creature);
			}
			for each (var c:Creature in toRemove)
				removeCreature(c);
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
		
		public function addBlood(x:int, y:int, amount:int):void
		{
			if (amount < 1)
			{
				addBlood1(x, y, amount);
				return;
			}
			
			addBlood1(x, y);
			for (var i:int = 1; i < amount; i++)
				addBlood1(x + (int)(Math.random() * 3) - 1, y + (int)(Math.random() * 3) - 1);
		}
		
		private function addBlood1(x:int, y:int, amount:int = 1):void
		{
			bloodGrid[x][y] = Math.min(Math.max(0, getBlood(x, y) + amount), 9);
		}
		
		public function getBlood(x:int, y:int):int
		{
			return bloodGrid[x][y];
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
			for each (var animation:Animation in animationList)
			{
				animation.update();
				if (!animation.done)
					nextAnimations.push(animation);
			}
			animationList = nextAnimations;
		}
		
		public function addFog(x:int, y:int, amount:int, payload:Payload):void 
		{
			fogGrid[x][y] = new Fog(amount, payload);
			fogPoints.push(new Point(x, y));
		}
		
		public function disipateFog():void
		{
			var newFog:Array = grid(null);
			var newFogPoints:Array = [];
			
			for each (var fogPoint:Point in fogPoints)
			{
				var x:int = fogPoint.x;
				var y:int = fogPoint.y;
				
				var fog:Fog = fogGrid[x][y];
				var amount:int = fog.amount - 1;
				
				if (amount < 1)
					continue;
				
				for each (var offsets:Array in [[ -1, 0], [1, 0], [0, -1], [0, 1]])
				{
					if (Math.random() < 0.25)
						continue;
					
					var x2:int = x + offsets[0];
					var y2:int = y + offsets[1];
					
					if (amount < 3 || getTile(x2, y2).blocksArrows)
						continue;
					
					var fog2:Fog = fogGrid[x2][y2];
					var diff:int = fog2 == null ? amount : amount - fog2.amount;
					
					if (diff < 1)
						continue;
					
					var spillOver:int = diff / 2;
					
					amount -= spillOver;
					
					if (newFog[x2][y2] == null)
					{
						newFog[x2][y2] = new Fog(spillOver, fog.payload);
						newFogPoints.push(new Point(x2, y2));
					}
					else if (newFog[x2][y2].payload.isSameAs(fog.payload))
					{
						newFog[x2][y2].amount += spillOver;
					}
					else if (newFog[x2][y2].amount < spillOver)
					{
						newFog[x2][y2] = new Fog(spillOver, fog.payload);
					}
				}
				
				if (amount > 0)
				{
					if (newFog[x][y] == null)
					{
						newFog[x][y] = new Fog(amount, fog.payload);
						newFogPoints.push(new Point(x, y));
					}
					else if (newFog[x][y].payload.isSameAs(fog.payload))
					{
						newFog[x][y].amount += amount;
					}
					else if (newFog[x][y].amount < amount)
					{
						newFog[x][y] = new Fog(amount, fog.payload);
					}
				}
			}
			
			fogGrid = newFog;
			fogPoints = newFogPoints;
			
			for each (var p:Point in newFogPoints)
				newFog[p.x][p.y].payload.hitTile(this, p.x, p.y);
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