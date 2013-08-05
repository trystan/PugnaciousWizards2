package  
{
	import flash.geom.Point;
	import payloads.Healing;
	import payloads.Payload;
	import payloads.Poison;
	public class Tile 
	{
		public static var dirt:Tile = new Tile("dirt", null, false, false, false);
		public static var grass:Tile = new Tile("grass", null, false, false, false, 0.1);
		public static var grass_fire:Tile = new Tile("burning grass", null, false, false, false);
		public static var tree:Tile = new Tile("tree", null, true, false, false, 0.25);
		public static var tree_fire_3:Tile = new Tile("burning tree", null, true, false, false);
		public static var tree_fire_2:Tile = new Tile("burning tree", null, true, false, false);
		public static var tree_fire_1:Tile = new Tile("burning tree", null, true, false, false);
		public static var floor_light:Tile = new Tile("floor", null, false, false, false);
		public static var floor_dark:Tile = new Tile("floor", null, false, false, false);
		public static var mystic_floor_light:Tile = new Tile("floor with mystic symbols", "These mystic symbols negate all magic.", false, false, false);
		public static var mystic_floor_dark:Tile = new Tile("floor with mystic symbols", "These mystic symbols negate all magic.", false, false, false);
		public static var bars_h:Tile = new Tile("bars", null, true, false, false);
		public static var bars_v:Tile = new Tile("bars", null, true, false, false);
		public static var wall:Tile = new Tile("wall", null, true, true, true);
		public static var moving_wall:Tile = new Tile("moving wall on a track", "This giant block moves on a track etched into the floor.", true, true, false, 0, null, false);
		public static var stone_door_closed:Tile = new Tile("closed stone door", "Bump into this stone door to open it. Like all stone, it can't be burnt.", true, true, true, 0.25);
		public static var stone_door_opened:Tile = new Tile("open door", null, false, false, false, 0.25);
		public static var wood_door_closed:Tile = new Tile("closed wooden door", "Bump into this wooden door to open it. Like all wooden things, it can be burnt.", true, true, true, 0.25);
		public static var wood_door_opened:Tile = new Tile("open door", null, false, false, false, 0.25);
		public static var door_closed_fire:Tile = new Tile("burning closed door", null, true, true, true);
		public static var door_opened_fire:Tile = new Tile("burning open door", null, false, false, false);
		static public var tower:Tile = new Tile("arrow tower", "This tower shoots arrows in eight direction.", true, true, false);
		static public var tower_1:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in two directions.", true, true, false);
		static public var tower_2:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in two directions.", true, true, false);
		static public var tower_3:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in two directions.", true, true, false);
		static public var tower_4:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in two directions.", true, true, false);
		static public var tower_5:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in four directions.", true, true, false);
		static public var tower_6:Tile = new Tile("rotating arrow tower", "This tower rotates and shoots arrows in four directions.", true, true, false);
		static public var burnt_ground:Tile = new Tile("burt ground", null, false, false, false);
		static public var shallow_water:Tile = new Tile("shallow water", "There is a shallow pool of water here.", false, false, false, 0, waterEffect);
		static public var poison_water:Tile = new Tile("poison water", "There is a shallow pool of poisoned water here.", false, false, false, 0, poisonedWaterEffect);
		static public var frozen_water:Tile = new Tile("ice", "There is some very slippery ice here.", false, false, false, 0, iceEffect);
		
		public static var sparcePoisonFog:Tile = new Tile("poison fog", "This poisonous fog is too thick to see through.", false, false, false, 0, poisonedFogEffect, false);
		public static var densePoisonFog:Tile = new Tile("poison fog", "This poisonous fog is too thick to see through.", false, false, true, 0, poisonedFogEffect, false);
		public static var sparceHealingFog:Tile = new Tile("healing fog", "This healing fog is too thick to see through.", false, false, false, 0, healingFogEffect, false);
		public static var denseHealingFog:Tile = new Tile("healing fog", "This healing fog is too thick to see through.", false, false, true, 0, healingFogEffect, false);
		
		
		
		static public var portal:Tile = new Tile("glowing portal", "This portal glows brightly. You can't see where it leads.", false, false, false, 0, portalEffect);
		
		static public var ice_tower:Tile = new Tile("ice tower", "This tower shoots freezing arrows in eight directions.", true, true, false);
		static public var ice_tower_1:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows in two directions.", true, true, false);
		static public var ice_tower_2:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows in two directions.", true, true, false);
		static public var ice_tower_3:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows in two directions.", true, true, false);
		static public var ice_tower_4:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows in two directions.", true, true, false);
		static public var ice_tower_5:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows in four directions.", true, true, false);
		static public var ice_tower_6:Tile = new Tile("rotating ice tower", "This rotating tower shoots freezing arrows in four directions.", true, true, false);
		
		static public var fire_tower:Tile = new Tile("fire tower", "This tower shoots fiery arrows in eight directions.", true, true, false);
		static public var fire_tower_1:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows in two directions.", true, true, false);
		static public var fire_tower_2:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows in two directions.", true, true, false);
		static public var fire_tower_3:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows in two directions.", true, true, false);
		static public var fire_tower_4:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows in two directions.", true, true, false);
		static public var fire_tower_5:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows in four directions.", true, true, false);
		static public var fire_tower_6:Tile = new Tile("rotating fire tower", "This rotating tower shoots fiery arrows in four directions.", true, true, false);
		
		static public var out_of_bounds:Tile = new Tile("**OUT OF BOUNDS**", null, true, true, true);
		
		static public var track_light_ns:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_dark_ns:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_light_we:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_dark_we:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_light_ne:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_dark_ne:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_light_sw:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_dark_sw:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_light_nw:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_dark_nw:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_light_se:Tile = new Tile("floor with a track in it", null, false, false, false);
		static public var track_dark_se:Tile = new Tile("floor with a track in it", null, false, false, false);
		
		
		public var name:String;
		public var description:String;
		public var blocksMovement:Boolean;
		public var blocksArrows:Boolean;
		public var burnChance:Number;
		public var blocksVision:Boolean;
		public var standOnFunction:Function;
		public var remember:Boolean;
		
		public function Tile(name:String, description:String, blocksMovement:Boolean, blocksArrows:Boolean, blocksVision:Boolean, burnChance:Number = 0.0, standOnFunction:Function = null, remember:Boolean = true) 
		{
			this.name = name;
			this.description = description;
			this.blocksMovement = blocksMovement;
			this.blocksArrows = blocksArrows;
			this.blocksVision = blocksVision;
			this.burnChance = burnChance;
			this.standOnFunction = standOnFunction;
			this.remember = remember;
		}
		
		public function apply(creature:Creature):void
		{
			if (standOnFunction != null)
				standOnFunction(creature);
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
		}
		
		private static function poisonedFogEffect(creature:Creature):void
		{
			new Poison().hitCreature(creature);
		}
		
		private static function iceEffect(creature:Creature):void
		{
			if (!creature.world.getTile(creature.position.x + creature.movedBy.x, creature.position.y + creature.movedBy.y).blocksMovement)
				creature.moveBy(creature.movedBy.x, creature.movedBy.y);
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
		
		static public function denseFogFor(payload:Payload):Tile 
		{
			if (payload is Poison)
				return Tile.densePoisonFog;
			else
				return Tile.denseHealingFog;
		}
		
		static public function sparceFogFor(payload:Payload):Tile 
		{
			if (payload is Poison)
				return Tile.sparcePoisonFog;
			else
				return Tile.sparceHealingFog;
		}
	}
}