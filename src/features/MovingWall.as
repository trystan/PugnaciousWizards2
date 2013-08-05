package features 
{
	public class MovingWall extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var direction:String;
		
		public var oldTile:Tile;
		
		public function MovingWall(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.direction = "W";
				
			oldTile = world.getTile(x, y);
			update();
		}
		
		override public function update():void
		{
			followTrack(oldTile);
			
			var mx:int = 0;
			var my:int = 0;
			switch (direction)
			{
				case "N": my = -1; break;
				case "S": my = 1; break;
				case "W": mx = -1; break;
				case "E": mx = 1; break;
			}
			
			if (!isTrack(world.getTile(x + mx, y + my)))
			{
				reverseDirection(oldTile);
				
				mx = 0;
				my = 0;
				switch (direction)
				{
					case "N": my = -1; break;
					case "S": my = 1; break;
					case "W": mx = -1; break;
					case "E": mx = 1; break;
				}
			}
			
			world.addTile(x, y, oldTile);
			x += mx;
			y += my;
			oldTile = world.getTile(x, y);
			world.addTile(x, y, Tile.moving_wall);
			
			var creature:Creature = world.getCreature(x, y);
			if (creature != null)
			{
				creature.moveBy(mx, my, false, true);
				if (world.getTile(x + mx, y + my).blocksMovement)
					creature.hurt(1000, "You've been crushed to death by a moving wall piece.");
			}
		}
		
		private function followTrack(tile:Tile):void 
		{
			switch (tile)
			{
				case Tile.track_dark_ns:
				case Tile.track_light_ns:
					if (direction != "N" && direction != "S")
						direction = Math.random() < 0.5 ? "N" : "S";
					break;
				case Tile.track_dark_we:
				case Tile.track_light_we:
					if (direction != "W" && direction != "E")
						direction = Math.random() < 0.5 ? "W" : "E";
					break;
				case Tile.track_dark_nw:
				case Tile.track_light_nw:
					if (direction == "S")
						direction = "W";
					else if (direction == "E")
						direction = "N";
					else
						direction = Math.random() < 0.5 ? "N" : "W";
					break;
				case Tile.track_dark_ne:
				case Tile.track_light_ne:
					if (direction == "S")
						direction = "E";
					else if (direction == "W")
						direction = "N";
					else
						direction = Math.random() < 0.5 ? "N" : "E";
					break;
					
				case Tile.track_dark_sw:
				case Tile.track_light_sw:
					if (direction == "N")
						direction = "W";
					else if (direction == "E")
						direction = "S";
					else
						direction = Math.random() < 0.5 ? "S" : "W";
					break;
				case Tile.track_dark_se:
				case Tile.track_light_se:
					if (direction == "N")
						direction = "E";
					else if (direction == "W")
						direction = "S";
					else
						direction = Math.random() < 0.5 ? "S" : "E";
					break;
			}
		}
		
		private function reverseDirection(tile:Tile):void 
		{
			switch (tile)
			{
				case Tile.track_dark_ns:
				case Tile.track_light_ns:
					if (direction == "N")
						direction = "S";
					else if (direction == "S")
						direction = "N";
					break;
				case Tile.track_dark_we:
				case Tile.track_light_we:
					if (direction == "W")
						direction = "E";
					else if (direction == "E")
						direction = "W";
					break;
				case Tile.track_dark_nw:
				case Tile.track_light_nw:
					if (direction == "N")
						direction = "W";
					else if (direction == "W")
						direction = "N";
					break;
				case Tile.track_dark_ne:
				case Tile.track_light_ne:
					if (direction == "N")
						direction = "E";
					else if (direction == "E")
						direction = "N";
					break;
					
				case Tile.track_dark_sw:
				case Tile.track_light_sw:
					if (direction == "W")
						direction = "S";
					else if (direction == "S")
						direction = "W";
					break;
				case Tile.track_dark_se:
				case Tile.track_light_se:
					if (direction == "E")
						direction = "S";
					else if (direction == "S")
						direction = "E";
					break;
			}
		}
		
		private var tracks:Array = [
			Tile.track_dark_ns, Tile.track_light_ns,
			Tile.track_dark_we, Tile.track_light_we,
			Tile.track_dark_nw, Tile.track_light_nw,
			Tile.track_dark_ne, Tile.track_light_ne,
			Tile.track_dark_sw, Tile.track_light_sw,
			Tile.track_dark_se, Tile.track_light_se,
		];
		
		private function isTrack(tile:Tile):Boolean 
		{
			return tracks.indexOf(tile) > -1;
		}
	}
}