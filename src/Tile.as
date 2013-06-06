package  
{
	public class Tile 
	{
		public static var grass:Tile = new Tile(false, false, false, 0.1);
		public static var grass_fire:Tile = new Tile(false, false, false);
		public static var tree:Tile = new Tile(true, true, false, 0.25);
		public static var tree_fire_3:Tile = new Tile(true, true, false);
		public static var tree_fire_2:Tile = new Tile(true, true, false);
		public static var tree_fire_1:Tile = new Tile(true, true, false);
		public static var floor_light:Tile = new Tile(false, false, false);
		public static var floor_dark:Tile = new Tile(false, false, false);
		public static var wall:Tile = new Tile(true, true, true);
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
		
		public var blocksMovement:Boolean;
		public var blocksArrows:Boolean;
		public var burnChance:Number;
		public var blocksVision:Boolean;
		
		public function Tile(blocksMovement:Boolean, blocksArrows:Boolean, blocksVision:Boolean, burnChance:Number = 0.0) 
		{
			this.blocksMovement = blocksMovement;
			this.blocksArrows = blocksArrows;
			this.blocksVision = blocksVision;
			this.burnChance = burnChance;
		}
	}
}