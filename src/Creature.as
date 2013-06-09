package  
{
	import features.BurningFire;
	import flash.geom.Point;
	import spells.FireJump;
	import spells.Spell;
	
	public class Creature 
	{
		public var type:String;
		public var position:Point;
		public var world:World;
		public var endPiecesPickedUp:int = 0;
		public function get hasAllEndPieces():Boolean { return endPiecesPickedUp == 3; }
		
		public var health:int;
		public var maxHealth:int;
		public var causeOfDeath:String = "";
		public var visionRadius:int = 9;
		public var bleedingCounter:int = 0;
		private var vision:SimpleLineOfSight;
		
		public var fireCounter:int = 0;
		public var freezeCounter:int = 0;
		
		public var magic:Array = [];
		
		public function Creature(position:Point, type:String) 
		{
			this.type = type;
			this.position = position;
			
			maxHealth = 100;
			health = maxHealth;
			
			vision = new SimpleLineOfSight(this);
		}
		
		public function moveBy(x:Number, y:Number):void 
		{
			if (freezeCounter > 0)
				return;
			
			if (world.isClosedDoor(position.x + x, position.y + y))
				world.openDoor(position.x + x, position.y + y);
			else if (x == 0 && y == 0)
			{
				// stand still
			}
			else if (world.getTile(position.x + x, position.y + y) == Tile.portal)
			{
				var candidates:Array = [];
				
				for (var ox:int = 0; ox < 80; ox++)
				for (var oy:int = 0; oy < 80; oy++)
				{
					if (world.getTile(ox, oy) == Tile.portal)
						candidates.push(new Point(ox, oy));
				}
				
				var target:Point = candidates[(int)(Math.random() * candidates.length)];
				
				var tx:int = 0;
				var ty:int = 0;
				do
				{
					tx = target.x + (int)(Math.random() * 3 - 1);
					ty = target.y + (int)(Math.random() * 3 - 1);
				}
				while (world.getTile(tx, ty) == Tile.portal || world.getTile(tx, ty).blocksMovement);
				
				moveTo(tx, ty);
			}
			else if (!world.getTile(position.x + x, position.y + y).blocksMovement)
			{
				var other:Creature = world.getCreatureAt(position.x + x, position.y + y);
				if (other != null)
				{
					if (isEnemy(other))
						melee(other);
				}
				else	
				{
					position.x += x;
					position.y += y;
				}
			}
			
			getStuffHere();
		}
		
		public function isEnemy(other:Creature):Boolean
		{
			return this.type != other.type;
		}
		
		private function melee(other:Creature):void 
		{
			other.takeDamage(5, "Slain by a " + type.toLowerCase() + ".");
		}
		
		public function moveTo(x:int, y:int):void
		{
			if (freezeCounter > 0)
				return;
				
			position.x = x;
			position.y = y;
			
			getStuffHere();
		}
		
		public function update():void
		{
			if (health < 1)
				return;
							
			if (world.getTile(position.x, position.y) == Tile.shallow_water)
			{
				fireCounter = Math.max(0, fireCounter - 10);
			}
				
			if (fireCounter > 0)
			{
				if (Math.random() < 0.1)
					world.addFeature(new BurningFire(world, position.x, position.y));
				
				takeDamage(3, "Burned to death.");
				fireCounter--;
			}
			
			if (bleedingCounter > 0)
			{
				takeDamage(1, "Bleed to death.");
				bleedingCounter--;
			}
			
			if (freezeCounter > 0)
			{
				freezeCounter--;
			}
			
			if (freezeCounter < 1 && health > 0)
				doAi();
		}
		
		public function doAi():void
		{
		}
		
		protected function wanderRandomly():void 
		{
			moveBy((int)(Math.random() * 3) - 1, (int)(Math.random() * 3) - 1);
		}
		
		private function getStuffHere():void
		{
			var item:Item = world.getItem(position.x, position.y);
			if (item is EndPiece)
			{
				world.removeItem(position.x, position.y);
				endPiecesPickedUp++;
			}
			else if (item is Scroll && magic.length < 9)
			{
				world.removeItem(position.x, position.y);
				addMagicSpell((item as Scroll).spell);
			}
		}
		
		public function addMagicSpell(spell:Spell):void
		{
			magic.push(spell);
		}
		
		public function get canCastMagic():Boolean 
		{
			if (freezeCounter > 0)
				return false;
				
			var room:Room = world.getRoom(position.x, position.y);
			if (room != null && room.forbidMagic)
				return false;
				
			return true;
		}
		
		public function castSpell(index:int, callback:Function):void
		{
			if (!canCastMagic)
				return;
				
			if (magic.length <= index)
				return;
				
			(magic[index] as Spell).playerCast(this, callback);
		}
		
		public function takeDamage(amount:int, causeOfDeath:String):void 
		{
			health -= amount;
			
			bleedingCounter += amount / 5;
			world.addBlood(position.x, position.y, amount / 3 + 1);
			
			if (health < 1)
			{
				this.causeOfDeath = causeOfDeath;
				world.removeCreature(this);
			}
		}
		
		public function canSeeCreature(other:Creature):Boolean
		{
			return canSee(other.position.x, other.position.y);
		}
		
		public function canSee(x:int, y:int):Boolean
		{
			return vision.canSee(x, y);
		}
		
		public function hasSeen(x:int, y:int):Boolean 
		{
			return vision.hasSeen(x, y);
		}
		
		public function memory(x:int, y:int):Tile 
		{
			return vision.remembered(x, y);
		}
		
		public function burn(amount:int):void 
		{
			if (freezeCounter > 0)
			{
				var overlap:int = Math.min(freezeCounter, amount);
				freezeCounter -= overlap;
				amount -= overlap;
			}
			
			fireCounter += amount;
		}
		
		public function freeze(amount:int):void 
		{
			if (fireCounter > 0)
			{
				var overlap:int = Math.min(fireCounter, amount);
				fireCounter -= overlap;
				amount -= overlap;
			}
			
			if (freezeCounter == 0)
				freezeCounter += amount;
		}
	}
}