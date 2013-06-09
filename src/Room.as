package  
{
	import flash.display.InterpolationMethod;
	import flash.geom.Point;
	import themes.RoomTheme;
	import themes.RoomThemeFactory;
	import themes.TreasureRoom;
	
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
		public var forbidMagic:Boolean = false;
		
		public function Room(x:int, y:int) 
		{
			position = new Point(x, y);
			worldPosition = new Point(x * 8 + 5, y * 8 + 5);
			theme = RoomThemeFactory.random();
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
			if (isDeadEnd)
			{
				new TreasureRoom().apply(this, world);
			}
			else
			{
				addRandomArchitecture(world);
				addRoomArchitecture(world);
				
				theme.apply(this, world);
				
				addEnemies(world);
			}
		}
		
		public function addRoomArchitecture(world:World):void
		{
			var r:Number = Math.random();
			
			if (r < 0.125 * 2)
			{
				world.addWall(worldPosition.x + 0, worldPosition.y + 0);
				world.addWall(worldPosition.x + 6, worldPosition.y + 0);
				world.addWall(worldPosition.x + 6, worldPosition.y + 6);
				world.addWall(worldPosition.x + 0, worldPosition.y + 6);
			}
			else if (r < 0.125 * 3)
			{
				world.addWall(worldPosition.x + 1, worldPosition.y + 1);
				world.addWall(worldPosition.x + 5, worldPosition.y + 1);
				world.addWall(worldPosition.x + 5, worldPosition.y + 5);
				world.addWall(worldPosition.x + 1, worldPosition.y + 5);
				
				if (Math.random() < 0.25)
				{
					world.addWall(worldPosition.x + 1, worldPosition.y + 3);
					world.addWall(worldPosition.x + 3, worldPosition.y + 1);
					world.addWall(worldPosition.x + 3, worldPosition.y + 5);
					world.addWall(worldPosition.x + 5, worldPosition.y + 3);
				}
			}
		}
				
		public function addRandomArchitecture(world:World):void
		{
			var chance:Number = 75;
			while (Math.random() < chance)
			{
				var px:int = Math.random() * 5 + 1;
				var py:int = Math.random() * 5 + 1;
				world.addWall(worldPosition.x + px, worldPosition.y + py);
				
				chance = 0.25;
			}
		}
		
		public function contains(x:int, y:int):Boolean 
		{
			return worldPosition.x <= x && worldPosition.y <= y && worldPosition.x + 7 > x && worldPosition.y + 7 > y;
		}
		
		private function addEnemies(world:World):void 
		{
			while (Math.random() < 0.33)
			{
				var px:int = Math.random() * 7 + 1;
				var py:int = Math.random() * 7 + 1;
				
				if (world.getTile(worldPosition.x + px, worldPosition.y + py).blocksMovement)
					continue;
					
				if (Math.random() < 66)
					world.add(new Guard(new Point(worldPosition.x + px, worldPosition.y + py)));
				else
					world.add(new Archer(new Point(worldPosition.x + px, worldPosition.y + py)));
			}
		}
	}
}