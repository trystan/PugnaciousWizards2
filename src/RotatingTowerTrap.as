package  
{
	public class RotatingTowerTrap extends CastleEffect
	{
		private static var directions:Array = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"];
		
		public var x:int;
		public var y:int;
		public var world:World;
		public var directionIndex:int;
		public function get direction():String { return directions[directionIndex]; }
		
		public function RotatingTowerTrap(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.directionIndex = (int)(Math.random() * 8);
			
			updateWorld();
		}
		
		override public function update():void
		{
			directionIndex++;
			if (directionIndex == 8)
				directionIndex = 0;
			
			updateWorld();
			
			Main.addAnimation(new Arrow(world, x, y, directions[directionIndex]));
			Main.addAnimation(new Arrow(world, x, y, directions[(directionIndex + 4) % 8]));
		}
		
		private function updateWorld():void
		{
			switch (direction)
			{
				case "N":
				case "S":
					world.addTile(x, y, Tile.tower_1);
					break;
				case "NE":
				case "SW":
					world.addTile(x, y, Tile.tower_2);
					break;
				case "E":
				case "W":
					world.addTile(x, y, Tile.tower_3);
					break;
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.tower_4);
					break;
			}
		}
	}
}