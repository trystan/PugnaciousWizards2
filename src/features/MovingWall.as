package features 
{
	public class MovingWall extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var mx:int;
		public var my:int;
		
		public var oldTile:Tile;
		
		public function MovingWall(world:World, x:int, y:int, mx:int, my:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.mx = mx;
			this.my = my;
			
			oldTile = world.getTile(x, y);
			update();
		}
		
		override public function update():void
		{
			if (world.blocksMovement(x + mx, y + my) 
				|| world.isOpenedDoor(x + mx, y + my) 
				|| world.isClosedDoor(x + mx, y + my))
			{
				mx *= -1;
				my *= -1;
			}
			
			world.addTile(x, y, oldTile);
			x += mx;
			y += my;
			oldTile = world.getTile(x, y);
			world.addTile(x, y, Tile.moving_wall);
			
			var creature:Creature = world.getCreatureAt(x, y);
			if (creature != null)
			{
				creature.moveBy(mx, my);
				if (world.blocksMovement(x + mx, y + my))
					creature.takeDamage(1000, "Crushed to death by a moving wall piece.");
			}
		}
	}
}