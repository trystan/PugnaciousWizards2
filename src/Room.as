package  
{
	import flash.display.InterpolationMethod;
	import flash.geom.Point;
	
	public class Room 
	{
		public var position:Point;
		public var theme:RoomTheme;
		
		public var isConnectedNorth:Boolean = false;
		public var isConnectedSouth:Boolean = false;
		public var isConnectedWest:Boolean = false;
		public var isConnectedEast:Boolean = false;
		public var isEndRoom:Boolean = false;
		
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
			
			if (isEndRoom)
			{
				for (var tx:int = 0; tx < 5; tx++)
				for (var ty:int = 0; ty < 5; ty++)
				{
					var x:int = position.x * 8 + 8 + tx - 2;
					var y:int = position.y * 8 + 8 + ty - 2;
					world.addTile(x, y, (x + y) % 2 == 0 ? Tile.floor_light : Tile.floor_dark);
				}
				world.addItem(position.x * 8 + 8, position.y * 8 + 8, new EndPiece());
			}
		}
	}
}