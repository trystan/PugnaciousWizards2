package  
{
	import animations.Explosion;
	import flash.geom.Point;
	import payloads.Fire;
	import payloads.Healing;
	import payloads.Ice;
	import payloads.Payload;
	import payloads.Poison;
	public class Tile 
	{
		public static var dirt:Tile = new Tile("dirt", null, false, false, 0.0);
		public static var grass:Tile = new Tile("grass", null, false, false, 0.0, 0.1);
		public static var grass_fire:Tile = new Tile("burning grass", null, false, false, 0.0, 0, null, true, true);
		public static var tree:Tile = new Tile("tree", null, true, false, 0.0, 0.25);
		public static var tree_fire_3:Tile = new Tile("burning tree", null, true, false, 0.0, 0, null, true, true);
		public static var tree_fire_2:Tile = new Tile("burning tree", null, true, false, 0.0, 0, null, true, true);
		public static var tree_fire_1:Tile = new Tile("burning tree", null, true, false, 0.0, 0, null, true, true);
		public static var floor_light:Tile = new Tile("floor", null, false, false, 0.0);
		public static var floor_dark:Tile = new Tile("floor", null, false, false, 0.0);
		public static var mystic_floor_light:Tile = new Tile("floor with mystic symbols", "These mystic symbols negate all magic.", false, false, 0.0);
		public static var mystic_floor_dark:Tile = new Tile("floor with mystic symbols", "These mystic symbols negate all magic.", false, false, 0.0);
		public static var bars_h:Tile = new Tile("bars", null, true, false, 0.0);
		public static var bars_v:Tile = new Tile("bars", null, true, false, 0.0);
		public static var wall:Tile = new Tile("wall", null, true, true, 1.0);
		public static var moving_wall:Tile = new Tile("moving wall on a track", "This giant block moves on a track etched into the floor.", true, true, 0.0, 0, null, false);
		public static var stone_door_closed:Tile = new Tile("closed stone door", "Bump into this door to open it. Wooden doors can be burnt but stone ones can't.", true, true, 1.0, 0.25);
		public static var stone_door_opened:Tile = new Tile("open door", null, false, false, 0.0, 0.25);
		public static var wood_door_closed:Tile = new Tile("closed wooden door", null, true, true, 1.0, 0.25);
		public static var wood_door_opened:Tile = new Tile("open door", null, false, false, 0.0, 0.25);
		public static var door_closed_fire:Tile = new Tile("burning closed door", null, true, true, 1.0, 0, null, true, true);
		public static var door_opened_fire:Tile = new Tile("burning open door", null, false, false, 0.0, 0, null, true, true);
		static public var tower:Tile = new Tile("arrow tower", "This tower shoots arrows in eight direction.", true, true, 0.0);
		static public var tower_1:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in two directions.", true, true, 0.0);
		static public var tower_2:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in two directions.", true, true, 0.0);
		static public var tower_3:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in two directions.", true, true, 0.0);
		static public var tower_4:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in two directions.", true, true, 0.0);
		static public var tower_5:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in four directions.", true, true, 0.0);
		static public var tower_6:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in four directions.", true, true, 0.0);
		static public var burnt_ground:Tile = new Tile("burt ground", null, false, false, 0.0);
		static public var shallow_water:Tile = new Tile("pool of shallow water", "There is a shallow pool of water here.", false, false, 0.0, 0, waterEffect);
		static public var poison_water:Tile = new Tile("pool of poison water", "There is a shallow pool of poisoned water here.", false, false, 0.0, 0, poisonedWaterEffect);
		static public var frozen_water:Tile = new Tile("pool of frozen water", "There is some very slippery ice here.", false, false, 0.0, 0, iceEffect);
		static public var magma:Tile = new Tile("magma", null, false, false, 0, 0, magmaEffect, true, true);
		
		public static var poisonFog:Tile = new Tile("poison fog", "This poisonous fog is so thick that you can't see very far through it.", false, false, 0.5, 0, poisonedFogEffect, false);
		public static var healingFog:Tile = new Tile("healing fog", "This healing fog is so thick that you can't see very far through it.", false, false, 0.5, 0, healingFogEffect, false);
		
		static public var portal:Tile = new Tile("glowing portal", "This portal glows brightly. You can't see where it leads to.", false, false, 0.0, 0, portalEffect);
		
		static public var ice_tower:Tile = new Tile("ice tower", "This tower shoots freezing arrows in eight directions.", true, true, 0.0);
		static public var ice_tower_1:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows.", true, true, 0.0);
		static public var ice_tower_2:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows.", true, true, 0.0);
		static public var ice_tower_3:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows.", true, true, 0.0);
		static public var ice_tower_4:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows.", true, true, 0.0);
		static public var ice_tower_5:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows.", true, true, 0.0);
		static public var ice_tower_6:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows.", true, true, 0.0);
		
		static public var fire_tower:Tile = new Tile("fire tower", "This tower shoots fiery arrows in eight directions.", true, true, 0.0);
		static public var fire_tower_1:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows.", true, true, 0.0);
		static public var fire_tower_2:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows.", true, true, 0.0);
		static public var fire_tower_3:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows.", true, true, 0.0);
		static public var fire_tower_4:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows.", true, true, 0.0);
		static public var fire_tower_5:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows.", true, true, 0.0);
		static public var fire_tower_6:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows.", true, true, 0.0);
		
		static public var poison_tower:Tile = new Tile("poison tower", "This tower shoots poison arrows in eight directions.", true, true, 0.0);
		static public var poison_tower_1:Tile = new Tile("rotating poison tower", "This rotating tower shoots poison arrows.", true, true, 0.0);
		static public var poison_tower_2:Tile = new Tile("rotating poison tower", "This rotating tower shoots poison arrows.", true, true, 0.0);
		static public var poison_tower_3:Tile = new Tile("rotating poison tower", "This rotating tower shoots poison arrows.", true, true, 0.0);
		static public var poison_tower_4:Tile = new Tile("rotating poison tower", "This rotating tower shoots poison arrows.", true, true, 0.0);
		static public var poison_tower_5:Tile = new Tile("rotating poison tower", "This rotating tower shoots poison arrows.", true, true, 0.0);
		static public var poison_tower_6:Tile = new Tile("rotating poison tower", "This rotating tower shoots poison arrows.", true, true, 0.0);
		
		static public var out_of_bounds:Tile = new Tile("**OUT OF BOUNDS**", null, true, true, 1.0);
		
		static public var track_light_ns:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_dark_ns:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_light_we:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_dark_we:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_light_ne:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_dark_ne:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_light_sw:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_dark_sw:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_light_nw:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_dark_nw:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_light_se:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		static public var track_dark_se:Tile = new Tile("floor with a track in it", null, false, false, 0.0);
		
		static public var fire_trap:Tile = new Tile("fire trap", null, false, false, 0.0, 0, fireTrap);
		static public var ice_trap:Tile = new Tile("ice trap", null, false, false, 0.0, 0, iceTrap);
		static public var poison_trap:Tile = new Tile("poison trap", null, false, false, 0.0, 0, poisonTrap);
		
		static public var golden_statue:Tile = new Tile("golden statue", "This statue of a skeleton is made of pure gold.", true, true, 1.0);
		
		public var name:String;
		public var description:String;
		public var blocksMovement:Boolean;
		public var blocksArrows:Boolean;
		public var burnChance:Number;
		public var blocksVision:Number;
		public var standOnFunction:Function;
		public var remember:Boolean;
		public var isOnFire:Boolean;
		
		public function Tile(name:String, description:String, blocksMovement:Boolean, blocksArrows:Boolean, blocksVision:Number, burnChance:Number = 0.0, standOnFunction:Function = null, remember:Boolean = true, isOnFire:Boolean = false) 
		{
			this.name = name;
			this.description = description;
			this.blocksMovement = blocksMovement;
			this.blocksArrows = blocksArrows;
			this.blocksVision = blocksVision;
			this.burnChance = burnChance;
			this.standOnFunction = standOnFunction;
			this.remember = remember;
			this.isOnFire = isOnFire;
		}
		
		public function apply(creature:Creature):void
		{
			if (standOnFunction != null)
				standOnFunction(creature);
		}
		
		private static function fireTrap(creature:Creature):void
		{
			creature.world.addAnimationEffect(
				new Explosion(creature.world, creature.position.x, creature.position.y, new Fire(), 25, true));
		}
		
		private static function iceTrap(creature:Creature):void
		{
			if (creature.freezeCounter > 0)
				return;
				
			creature.world.addAnimationEffect(
				new Explosion(creature.world, creature.position.x, creature.position.y, new Ice(), 25, true));
		}
		
		private static function poisonTrap(creature:Creature):void
		{
			creature.world.addAnimationEffect(
				new Explosion(creature.world, creature.position.x, creature.position.y, new Poison(), 25, true));
		}
		
		private static function waterEffect(creature:Creature):void
		{
			creature.fireCounter = 0;
		}
		
		private static function poisonedWaterEffect(creature:Creature):void
		{
			waterEffect(creature);
			new Poison().hitCreature(creature);
		}
		
		private static function healingFogEffect(creature:Creature):void
		{
			new Healing().hitCreature(creature);
			creature.world.getTile(creature.position.x, creature.position.y, true).apply(creature);
		}
		
		private static function poisonedFogEffect(creature:Creature):void
		{
			new Poison().hitCreature(creature);
			creature.world.getTile(creature.position.x, creature.position.y, true).apply(creature);
		}
		
		private static function iceEffect(creature:Creature):void
		{
			if (creature.movedBy.x == 0 && creature.movedBy.y == 0)
				return;
				
			if (creature.world.getTile(creature.position.x + creature.movedBy.x, creature.position.y + creature.movedBy.y).blocksMovement)
				return;
				
			creature.moveBy(creature.movedBy.x, creature.movedBy.y);
		}
		
		private static function magmaEffect(creature:Creature):void
		{
			creature.hurt(20, "You stepped in molten magma.");
			creature.burn(5);
		}
		
		private static function portalEffect(creature:Creature):void
		{	
			var candidates:Array = [];
			
			for (var ox:int = 0; ox < 80; ox++)
			for (var oy:int = 0; oy < 80; oy++)
			{
				if (creature.world.getTile(ox, oy) == Tile.portal)
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
			while (creature.world.getTile(tx, ty) == Tile.portal || creature.world.getTile(tx, ty).blocksMovement);
			
			creature.moveTo(tx, ty);
		}
		
		static public function fogFor(payload:Payload):Tile 
		{
			if (payload is Poison)
				return Tile.poisonFog;
			else
				return Tile.healingFog;
		}
	}
}