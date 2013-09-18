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
		public var numberOfAmuletsPickedUp:int = 0;
		public function get hasAllAmulets():Boolean { return numberOfAmuletsPickedUp == 3; }
		
		protected var _health:int;
		public function get health():int { return _health; };
		public var maxHealth:int;
		public var causeOfDeath:String = "";
		public var meleeDamage:int = 5;
		public var gold:int = 0;
		public var isAsleep:Boolean = false;
		
		public function get visionRadius():int { return blindCounter == 0 ? _visionRadius : 0; }
		public function set visionRadius(amount:int):void { _visionRadius = amount; }
		public function reduceVisionRadius():void { _visionRadius--; }
		
		private var _visionRadius:int;
		public var bleedingCounter:int = 0;
		private var vision:SimpleLineOfSight;
		
		public var poisonCounter:int = 0;
		public var fireCounter:int = 0;
		public var freezeCounter:int = 0;
		public var blindCounter:int = 0;
		public var isGoodGuy:Boolean = false;
		
		public var magic:Array = [];
		
		public var usesMagic:Boolean = false;
		
		public function Creature(position:Point, type:String, description:String) 
		{
			this.type = type;
			this.description = description;
			this.position = position;
			
			maxHealth = 100;
			_health = maxHealth;
			
			_visionRadius = CurrentGameVariables.defaultVisionRadius;
			vision = new SimpleLineOfSight(this);
		}
		
		public function moveBy(x:Number, y:Number, isBeingPushed:Boolean = false):void 
		{			
			if (freezeCounter > 0 && !isBeingPushed)
			{
				world.getTile(position.x, position.y).apply(this);
				return;
			}

			movedBy.x = 0;
			movedBy.y = 0;
	
			if (world.isClosedDoor(position.x + x, position.y + y))
			{
				if (isGoodGuy)
				{
					world.openDoor(position.x + x, position.y + y);
					
					if (world.getTile(position.x + x, position.y + y, true).isOnFire)
						burn(2);
					else if (fireCounter > 0 && world.getTile(position.x + x, position.y + y, true) == Tile.wood_door_opened)
						world.addTile(position.x + x, position.y + y, Tile.door_opened_fire);
				}
			}
			else if (x == 0 && y == 0)
			{
				// stand still
			}
			else if (world.getTile(position.x + x, position.y + y, true).blocksMovement)
			{
				vision.see(position.x + x, position.y + y);
			}
			else
			{
				var other:Creature = world.getCreature(position.x + x, position.y + y);
				
				if (other != null && other.swapsPositionWith(this))
				{
					position.x += x;
					position.y += y;
					movedBy.x = x;
					movedBy.y = y;
					
					other.moveTo(position.x - x, position.y - y);
				}
				else if (other != null)
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
		
		public function swapsPositionWith(other:Creature):Boolean
		{
			return false;
		}
		
		public function isEnemy(other:Creature):Boolean
		{
			return this.isGoodGuy != other.isGoodGuy 
						&& !(other.swapsPositionWith(this) || this.swapsPositionWith(other));
		}
		
		protected function melee(other:Creature):void 
		{
			other.hurt(meleeDamage, "You've been slain by a " + type.toLowerCase());
			other.bleed(2);
			
			if (fireCounter > 0 && other.fireCounter == 0)
				other.burn(2);
			else if (fireCounter == 0 && other.fireCounter > 0)
				burn(2);
		}
		
		public function moveTo(x:int, y:int):void
		{
			position.x = x;
			position.y = y;
			movedBy.x = 0;
			movedBy.y = 0;
			
			if (freezeCounter == 0)
				getStuffHere();
			
			vision.update();
			
			world.getTile(position.x, position.y).apply(this);
		}
		
		public function update():void
		{	
			vision.update();
			
			if (health < 1)
				return;
				
			if (poisonCounter > 0)
			{
				popup("you're poisoned", "You're poisoned!", "One of the many hazards of being an adventurer is the occasional poisoning.\n\nThe poison will wear off after a few turns. Or kill you.");
				hurt(CurrentGameVariables.poisonDamage, "You have been poisoned to death.");
				poisonCounter--;
			}
			
			if (fireCounter > 0)
			{
				if (Math.random() < world.getTile(position.x, position.y, true).burnChance)
					world.addFeature(new BurningFire(world, position.x, position.y));
				
				popup("you're burning", "You're on fire!", "One of the many hazards of being an adventurer is catching on fire every once in a while.\n\nThe fire will subside after a few turns - if you're still alive.");
				hurt(CurrentGameVariables.fireDamage, "You have burned to death.");
				fireCounter--;
			}
			
			if (bleedingCounter > 0)
			{
				popup("you're bleeding", "You're bleeding!", "One of the many hazards of being an adventurer is bloodloss from arrows and combat.\n\nYour wounds will stop bleeding in a few turns - unless you run out of blood first.");
				hurt(1, "You have bleed to death.");
				bleedingCounter--;
				world.addBlood(position.x, position.y, CurrentGameVariables.bloodloss);
			}
			
			if (freezeCounter > 0)
			{
				popup("you're frozen", "You're frozen!", "One of the many hazards of being an adventurer is getting frozen solid every once in a while.\n\nYou'll thaw out in a couple turns - if you're still alive.");
				hurt(CurrentGameVariables.iceDamage, "You have frozen to death.");
				freezeCounter--;
			}
			
			if (blindCounter > 0)
				blindCounter--;
				
			if (isAsleep && (world.player.canSeeCreature(this) || this.canSeeCreature(world.player)))
				isAsleep = false;
			
			if (!isAsleep && freezeCounter < 1 && health > 0)
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
			
			for each (var item:Item in world.getItems(position.x, position.y))
			{
				if (!item.canBePickedUpBy(this))
					continue;
					
				item.getPickedUpBy(this);
				world.removeItem(item);
			}
		}
		
		public function addMagicSpell(spell:Spell):void
		{
			magic.push(spell);
		}
		
		public function get canCastMagic():Boolean 
		{
			if (freezeCounter > 0 || !usesMagic)
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
		
		public function hurt(amount:int, causeOfDeath:String):void 
		{
			isAsleep = false;
			_health -= amount;
			checkDeath(causeOfDeath);
		}
		
		private function checkDeath(causeOfDeath:String):void
		{
			if (health > 0)
				return;
				
			this.causeOfDeath = causeOfDeath;
			world.removeCreature(this);
			die();
			dropGold();
		}
		
		private function dropGold():void
		{
			if (gold > 0)
			{
				world.addItem(position.x, position.y, new Gold());
				gold--;
			}
			
			while (gold > 0)
			{
				var x:int = position.x + Math.random() * 3 - 1;
				var y:int = position.y + Math.random() * 3 - 1;
				
				if (world.getTile(x, y, true).blocksMovement)
					continue;
				
				world.addItem(x, y, new Gold());
				gold--;
			}
		}
		
		public function die():void
		{
			world.addItem(position.x, position.y, new PileOfBones(this));
		}
		
		public function heal(amount:int, increaseMaxHealth:Boolean = false):void 
		{
			if (increaseMaxHealth)
				maxHealth = Math.max(health + amount, maxHealth);
			
			_health = Math.min(health + amount, maxHealth);
			checkDeath("You died from healing?");
		}
		
		public function bleed(amount:int):void
		{
			bleedingCounter = Math.min(999, bleedingCounter + amount);
			world.addBlood(position.x, position.y, amount);
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
		
		public function poison(amount:int):void
		{
			poisonCounter = Math.min(999, poisonCounter + amount);
		}
		
		public function burn(amount:int):void 
		{
			if (freezeCounter > 0)
				freezeCounter = 0;
			else
				fireCounter = Math.min(999, fireCounter + amount);
		}
		
		public function freeze(amount:int):void 
		{
			if (freezeCounter > 0)
				return;
			
			if (fireCounter > 0)
				fireCounter = 0;
			else
				freezeCounter = Math.min(999, freezeCounter + amount);
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
		
		public function foreachVisibleCreature(callback:Function):void 
		{
			for each (var other:Creature in world.creatures)
			{
				if (!canSeeCreature(other))
					continue;
				
				callback(other);
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
		
		public function describe(x:int, y:int):String
		{
			if (!hasSeen(x, y))
				return "Unknown";
			
			if (!canSee(x, y))
			{
				var memory:String = memory(x, y).name;
				
				return memory.charAt(0).toUpperCase() + memory.substr(1) + " (from memory)";
			}
			
			var text:String = "";
			
			var creature:Creature = world.getCreature(x, y);
			if (creature != null)
			{
				text += creature.type;
				
				var attribs:Array = []
				if (creature.fireCounter > 0)
					attribs.push("burning");
					
				if (creature.freezeCounter > 0)
					attribs.push("frozen");
				
				if (creature.bleedingCounter > 0)
					attribs.push("bleeding");
					
				if (creature.poisonCounter > 0)
					attribs.push("poisoned");
					
				if (creature.blindCounter > 0)
					attribs.push("blind");
				
				if (!isEnemy(creature) && this != creature)
					attribs.push("friendly (" + String.fromCharCode(3) + " " + creature.health + "/" + creature.maxHealth + ")");
					
				if (attribs.length > 0)
					text += " (" + attribs.join(", ") + ")"
					
				text += " standing on ";
			}
			
			var item:Item = world.getItem(x, y);
			if (item != null)
				text += item.name + " laying on ";
			
			switch (world.getBlood(x, y) / 3)
			{
				case 0: break;
				case 1: text += "blood splattered "; break;
				case 2: text += "bloody "; break;
				default: text += "blood covered "; break;
			}
			
			text += world.getTile(x, y).name;
			
			return text.charAt(0).toUpperCase() + text.substr(1);
		}
	}
}