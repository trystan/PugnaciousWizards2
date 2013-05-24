package  
{
	import flash.display.InterpolationMethod;
	import flash.geom.Point;
	
	public class Room 
	{
		public var worldPosition:Point;
		public var position:Point;
		public var theme:RoomTheme;
		
		public var isConnectedNorth:Boolean = false;
		public var isConnectedSouth:Boolean = false;
		public var isConnectedWest:Boolean = false;
		public var isConnectedEast:Boolean = false;
		public var isEndRoom:Boolean = false;
		
		public var distance:int = 0;
		
		private static var themes:Array = [
			new RoomTheme_empty(),
			new RoomTheme_empty(),
			new RoomTheme_empty(),
			new RoomTheme_courtyard(),
			new RoomTheme_trapFloors(),
			new RoomTheme_trapWalls(),
			new RoomTheme_trapTower(),
			new RoomTheme_rotatingTrapTower(),
		];
		
		public function Room(x:int, y:int) 
		{
			position = new Point(x, y);
			worldPosition = new Point(x * 8 + 5, y * 8 + 5);
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
			if (isEndRoom)
			{
				world.addItem(position.x * 8 + 8, position.y * 8 + 8, new EndPiece());
			}
			else
			{
				addRandomArchitecture(world);
			
				theme.apply(this, world);
			}
		}
		
		public function addRandomArchitecture(world:World):void
		{
			if (Math.random() < 0.125)
			{
				world.addWall(position.x * 8 + 5, position.y * 8 + 5);
				world.addWall(position.x * 8 + 11, position.y * 8 + 5);
				world.addWall(position.x * 8 + 11, position.y * 8 + 11);
				world.addWall(position.x * 8 + 5, position.y * 8 + 11);
			}
			
			while (Math.random() < 0.33)
			{
				var px:int = Math.random() * 5 + 6;
				var py:int = Math.random() * 5 + 6;
				world.addWall(position.x * 8 + px, position.y * 8 + py);
			}
		}
		
		public function contains(x:int, y:int):Boolean 
		{
			return worldPosition.x <= x && worldPosition.y <= y && worldPosition.x + 8 > x && worldPosition.y + 8> y;
		}
	}
}