package  
{
	import features.BurningFire;
	import flash.geom.Point;
	import spells.FireJump;
	import spells.Spell;
	
	public class Creature 
	{
		public var type:String;
		public var description:String;
		public var position:Point;
		public var movedBy:Point = new Point(0,0);
		public var world:World;
		public var endPiecesPickedUp:int = 0;
		public function get hasAllEndPieces():Boolean { return endPiecesPickedUp == 3; }
		
		public var health:int;
		public var maxHealth:int;
		public var causeOfDeath:String = "";
		public var meleeDamage:int = 5;
		
		public function get visionRadius():int { return blindCounter == 0 ? _visionRadius : 0; }
		public function set visionRadius(amount:int):void { _visionRadius = amount; }
		
		
		private var _visionRadius:int = 9;
		public var bleedingCounter:int = 0;
		private var vision:SimpleLineOfSight;
		
		public var fireCounter:int = 0;
		public var freezeCounter:int = 0;
		public var blindCounter:int = 0;
		public var isGoodGuy:Boolean = false;
		
		public var magic:Array = [];
		
		public function Creature(position:Point, type:String, description:String) 
		{
			this.type = type;
			this.description = description;
			this.position = position;
			
			maxHealth = 100;
			health = maxHealth;
			
			vision = new SimpleLineOfSight(this);
		}
		
		public function moveBy(x:Number, y:Number):void 
		{
			if (freezeCounter > 0)
			{
				world.getTile(position.x, position.y).apply(this);
				return;
			}
			
			if (world.isClosedDoor(position.x + x, position.y + y))
			{
				if (isGoodGuy)
					world.openDoor(position.x + x, position.y + y);
			}
			else if (x == 0 && y == 0)
			{
				// stand still
			}
			else if (world.getTile(position.x + x, position.y + y).blocksMovement)
			{
				vision.see(position.x + x, position.y + y);
			}
			else
			{
				var other:Creature = world.getCreature(position.x + x, position.y + y);
				if (other != null)
				{
					if (isEnemy(other))
						melee(other);
				}
				else	
				{
					position.x += x;
					position.y += y;
					movedBy.x = x;
					movedBy.y = y;
				}
			}
			
			getStuffHere();
			
			world.getTile(position.x, position.y).apply(this);
		}
		
		public function isEnemy(other:Creature):Boolean
		{
			return this.isGoodGuy != other.isGoodGuy;
		}
		
		private function melee(other:Creature):void 
		{
			other.takeDamage(meleeDamage, "Slain by a " + type.toLowerCase() + ".");
			other.bleed(5);
		}
		
		public function moveTo(x:int, y:int):void
		{
			if (freezeCounter > 0)
			{
				world.getTile(position.x, position.y).apply(this);
				return;
			}
				
			position.x = x;
			position.y = y;
			movedBy.x = 0;
			movedBy.y = 0;
			
			getStuffHere();
			
			world.getTile(position.x, position.y).apply(this);
		}
		
		public function update():void
		{	
			if (health < 1)
				return;
				
			if (fireCounter > 0)
			{
				if (Math.random() < 0.1)
					world.addFeature(new BurningFire(world, position.x, position.y));
				
				popup("you're burning", "You're on fire!", "One of the many hazards of being an adventurer is catching on fire every once in a while.\n\nThe fire will subside after a few turns - if you're still alive.");
				takeDamage(3, "Burned to death.");
				fireCounter--;
			}
			
			if (bleedingCounter > 0)
			{
				popup("you're bleeding", "You're bleeding!", "One of the many hazards of being an adventurer is getting hurt too much at once and bleeding.\n\nYour wounds will stop bleeding in a few turns - hopefully you'l still be alive.");
				takeDamage(1, "Bleed to death.");
				bleedingCounter--;
			}
			
			if (freezeCounter > 0)
			{
				popup("you're frozen", "You're frozen!", "One of the many hazards of being an adventurer is getting frozen solid every once in a while.\n\nYou'll thaw out in a couple turns - if you're still alive.");
				takeDamage(1, "Froze to death.");
				freezeCounter--;
			}
			
			if (blindCounter > 0)
				blindCounter--;
			
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
			if (blindCounter > 0)
				return;
				
			var item:Item = world.getItem(position.x, position.y);
			if (item != null && item.canBePickedUp())
				item.getPickedUpBy(this);
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
			world.getTile(position.x, position.y).apply(this);
			
			if (!canCastMagic)
				return;
				
			if (magic.length <= index)
				return;
				
			(magic[index] as Spell).playerCast(this, callback);
		}
		
		public function takeDamage(amount:int, causeOfDeath:String):void 
		{
			health -= amount;
			
			if (health < 1)
			{
				this.causeOfDeath = causeOfDeath;
				world.removeCreature(this);
				world.addItem(position.x, position.y, new PileOfBones(this));
			}
		}
		
		public function bleed(amount:int):void
		{
			bleedingCounter += amount;
			world.addBlood(position.x, position.y, amount + 1);
		}
		
		public function healBy(blood:int):void 
		{
			health = Math.min(health + blood, maxHealth);
		}
		
		public function canSeeCreature(other:Creature):Boolean
		{
			return canSee(other.position.x, other.position.y);
		}
		
		public function canSee(x:int, y:int):Boolean
		{
			if (blindCounter > 0)
				return false;
				
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
				freezeCounter = 0;
			else
				fireCounter += amount;
		}
		
		public function freeze(amount:int):void 
		{
			if (freezeCounter > 0)
				return;
				
			takeDamage(amount, "Froze to death.");
			
			if (fireCounter > 0)
				fireCounter = 0;
			else
				freezeCounter += amount;
		}
		
		public function foreachVisibleLocation(callback:Function):void 
		{
			for (var x:int = -visionRadius-1; x <= visionRadius+1; x++)
			for (var y:int = -visionRadius-1; y <= visionRadius+1; y++)
			{
				if (!canSee(x + position.x, y + position.y))
					continue;
				
				callback(x + position.x, y + position.y);
			}
		}
		
		public function blind(amount:int):void 
		{
			if (blindCounter == 0)
				blindCounter = amount;
		}
		
		private function popup(topic:String, title:String, text:String):void
		{
			if (this is Player)
				HelpSystem.popup(topic, title, text);
		}
	}
}