package  
{
	public class Tile 
	{
		public static var floor:Tile = new Tile(false);
		public static var wall:Tile = new Tile(true);
		public static var door_closed:Tile = new Tile(false);
		public static var door_opened:Tile = new Tile(false);
		
		public var blocksMovement:Boolean;
		
		public function Tile(blocksMovement:Boolean) 
		{
			this.blocksMovement = blocksMovement;
		}
	}
}