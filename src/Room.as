package  
{
	import flash.geom.Point;
	
	public class Room 
	{
		public var position:Point;
		public var theme:RoomTheme;
		
		public var isConnectedNorth:Boolean = false;
		public var isConnectedSouth:Boolean = false;
		public var isConnectedWest:Boolean = false;
		public var isConnectedEast:Boolean = false;
		
		private static var themes:Array = [
			new RoomTheme_randomPillars(),
			new RoomTheme_empty(),
			new RoomTheme_randomPillars(),
			new RoomTheme_empty(),
			new RoomTheme_circle(),
			new RoomTheme_courtyard(),
		];
		
		public function Room(x:int, y:int) 
		{
			position = new Point(x, y);
			theme = themes[Math.floor(Math.random() * themes.length)];
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
			theme.apply(this, world);
		}
	}
}