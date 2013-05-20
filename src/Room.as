package  
{
	import flash.geom.Point;
	
	public class Room 
	{
		public var position:Point;
		
		public var isConnectedNorth:Boolean = false;
		public var isConnectedSouth:Boolean = false;
		public var isConnectedWest:Boolean = false;
		public var isConnectedEast:Boolean = false;
		
		public function Room(x:int, y:int) 
		{
			position = new Point(x, y);
		}
	}
}