package features
{
	import animations.Arrow;
	
	public class TowerTrap extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var world:World;
		
		public function TowerTrap(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			
			world.addTile(x, y, Tile.tower);
		}
		
		override public function update():void
		{
			for each (var direction:String in ["N","E","S","W","NE","SE","SW","NW"])
				Main.addAnimation(new Arrow(world, x, y, direction));
		}
	}
}