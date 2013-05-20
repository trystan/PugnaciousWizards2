package  
{
	import flash.geom.Point;
	
	public class Room 
	{
		public var position:Point;
		
		public function Room(x:int, y:int) 
		{
			position = new Point(x, y);
		}	
	}
}