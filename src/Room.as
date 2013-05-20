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
		
		public function get isDeadEnd():Boolean 
		{
			var connections:int = 0;
			if (isConnectedNorth) connections++;
			if (isConnectedSouth) connections++;
			if (isConnectedWest) connections++;
			if (isConnectedEast) connections++;
			
			return connections == 1;
		}
		
		public function apply(world:World):void
		{
			var r:int = Math.random() * 100;
				
			if (r < 10)
			{
				world.addWall(position.x * 8 + 5, position.y * 8 + 5);
				world.addWall(position.x * 8 + 11, position.y * 8 + 5);
				world.addWall(position.x * 8 + 11, position.y * 8 + 11);
				world.addWall(position.x * 8 + 5, position.y * 8 + 11);
			}
			else if (!isDeadEnd)
			{
				while (Math.random() < 0.66)
				{
					var px:int = Math.random() * 5 + 6;
					var py:int = Math.random() * 5 + 6;
					world.addWall(position.x * 8 + px, position.y * 8 + py);
				}
			}
		}
	}
}