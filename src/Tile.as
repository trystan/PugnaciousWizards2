package  
{
	import flash.geom.Point;
	public class Tile 
	{
		public static var grass:Tile = new Tile(false, false, false, 0.1);
		public static var grass_fire:Tile = new Tile(false, false, false);
		public static var tree:Tile = new Tile(true, false, false, 0.25);
		public static var tree_fire_3:Tile = new Tile(true, false, false);
		public static var tree_fire_2:Tile = new Tile(true, false, false);
		public static var tree_fire_1:Tile = new Tile(true, false, false);
		public static var floor_light:Tile = new Tile(false, false, false);
		public static var floor_dark:Tile = new Tile(false, false, false);
		public static var mystic_floor_light:Tile = new Tile(false, false, false);
		public static var mystic_floor_dark:Tile = new Tile(false, false, false);
		public static var wall:Tile = new Tile(true, true, true);
		public static var moving_wall:Tile = new Tile(true, true, false, 0, null, false);
		public static var door_closed:Tile = new Tile(false, true, true, 0.25);
		public static var door_opened:Tile = new Tile(false, false, false, 0.25);
		public static var door_closed_fire:Tile = new Tile(false, true, true);
		public static var door_opened_fire:Tile = new Tile(false, false, false);
		static public var tower:Tile = new Tile(true, true, false);
		static public var tower_1:Tile = new Tile(true, true, false);
		static public var tower_2:Tile = new Tile(true, true, false);
		static public var tower_3:Tile = new Tile(true, true, false);
		static public var tower_4:Tile = new Tile(true, true, false);
		static public var burnt_ground:Tile = new Tile(false, false, false);
		static public var shallow_water:Tile = new Tile(false, false, false, 0, waterEffect);
		
		static public var portal:Tile = new Tile(false, false, false, 0, portalEffect);
		
		static public var ice_tower:Tile = new Tile(true, true, false);
		static public var ice_tower_1:Tile = new Tile(true, true, false);
		static public var ice_tower_2:Tile = new Tile(true, true, false);
		static public var ice_tower_3:Tile = new Tile(true, true, false);
		static public var ice_tower_4:Tile = new Tile(true, true, false);
		
		static public var fire_tower:Tile = new Tile(true, true, false);
		static public var fire_tower_1:Tile = new Tile(true, true, false);
		static public var fire_tower_2:Tile = new Tile(true, true, false);
		static public var fire_tower_3:Tile = new Tile(true, true, false);
		static public var fire_tower_4:Tile = new Tile(true, true, false);
		
		static public var out_of_bounds:Tile = new Tile(true, true, true);
		
		static public var track_light_ns:Tile = new Tile(false, false, false);
		static public var track_dark_ns:Tile = new Tile(false, false, false);
		static public var track_light_we:Tile = new Tile(false, false, false);
		static public var track_dark_we:Tile = new Tile(false, false, false);
		
		public var blocksMovement:Boolean;
		public var blocksArrows:Boolean;
		public var burnChance:Number;
		public var blocksVision:Boolean;
		public var standOnFunction:Function;
		public var remember:Boolean;
		
		public function Tile(blocksMovement:Boolean, blocksArrows:Boolean, blocksVision:Boolean, burnChance:Number = 0.0, standOnFunction:Function = null, remember:Boolean = true) 
		{
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
	}
}