package features
{
	import animations.Arrow;
	import payloads.Fire;
	import payloads.Ice;
	import payloads.Payload;
	import payloads.PayloadFactory;
	import payloads.Poison;
	
	public class RotatingTowerTrap_4Way extends CastleFeature
	{
		private static var directions:Array = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"];
		
		public var x:int;
		public var y:int;
		public var world:World;
		public var directionIndex:int;
		public function get direction():String { return directions[directionIndex]; }
		public var payload:Payload;
		
		public function RotatingTowerTrap_4Way(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.directionIndex = (int)(Math.random() * 8);
			this.payload = PayloadFactory.random();
			
			while (payload is Ice)
				payload = PayloadFactory.random();
			
			updateWorld();
		}
		
		override public function update():void
		{
			directionIndex++;
			if (directionIndex == 8)
				directionIndex = 0;
			
			updateWorld();
			
			new Arrow(world, x, y, directions[directionIndex], payload);
			new Arrow(world, x, y, directions[(directionIndex + 2) % 8], payload);
			new Arrow(world, x, y, directions[(directionIndex + 4) % 8], payload);
			new Arrow(world, x, y, directions[(directionIndex + 6) % 8], payload);
		}
		
		private function updateWorld():void
		{
			if (payload is Ice)
				updateWorld_ice();
			else if (payload is Fire)
				updateWorld_fire();
			else if (payload is Poison)
				updateWorld_poison();
			else
				updateWorld_piercing();
		}
		
		private function updateWorld_ice():void
		{
			switch (direction)
			{
				case "N":
				case "S":
				case "E":
				case "W":
					world.addTile(x, y, Tile.ice_tower_5);
					break;
				case "NE":
				case "SW":
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.ice_tower_6);
					break;
			}
		}
		
		private function updateWorld_fire():void
		{
			switch (direction)
			{
				case "N":
				case "S":
				case "E":
				case "W":
					world.addTile(x, y, Tile.fire_tower_5);
					break;
				case "NE":
				case "SW":
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.fire_tower_6);
					break;
			}
		}
		
		private function updateWorld_poison():void
		{
			switch (direction)
			{
				case "N":
				case "S":
				case "E":
				case "W":
					world.addTile(x, y, Tile.poison_tower_5);
					break;
				case "NE":
				case "SW":
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.poison_tower_6);
					break;
			}
		}
		
		private function updateWorld_piercing():void
		{
			switch (direction)
			{
				case "N":
				case "S":
				case "E":
				case "W":
					world.addTile(x, y, Tile.tower_5);
					break;
				case "NE":
				case "SW":
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.tower_6);
					break;
			}
		}
	}
}