package  
{
	import features.BurningFire;
	import flash.geom.Point;
	import spells.FireJump;
	import spells.Spell;
	
	public class Creature 
	{
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
		
		public function Creature(position:Point) 
		{
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
			else if (!world.getTile(position.x + x, position.y + y).blocksMovement)
			{
				var other:Creature = world.getCreatureAt(position.x + x, position.y + y);
				if (other != null)
				{
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
		
		private function melee(other:Creature):void 
		{
			other.takeDamage(5, "Killed in combat.");
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
				
			if (fireCounter > 0)
			{
				if (Math.random() < 0.1)
					world.addFeature(new BurningFire(world, position.x, position.y));
				
				takeDamage(2, "Burned to death.");
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
		
		public function castSpell(index:int, callback:Function):void
		{
			if (freezeCounter > 0)
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
			
			this.causeOfDeath = causeOfDeath;
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