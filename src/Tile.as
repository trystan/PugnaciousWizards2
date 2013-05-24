package  
{
	public class Tile 
	{
		public static var grass:Tile = new Tile(false, false);
		public static var tree:Tile = new Tile(true, true);
		public static var floor_light:Tile = new Tile(false, false);
		public static var floor_dark:Tile = new Tile(false, false);
		public static var wall:Tile = new Tile(true, true);
		public static var door_closed:Tile = new Tile(false, true);
		public static var door_opened:Tile = new Tile(false, false);
		
		public var blocksMovement:Boolean;
		public var blocksArrows:Boolean;
		
		public function Tile(blocksMovement:Boolean, blocksArrows:Boolean) 
		{
			this.blocksMovement = blocksMovement;
			this.blocksArrows = blocksArrows;
		}
	}
}