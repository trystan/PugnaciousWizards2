package  
{
	public class WallTrap extends CastleEffect
	{
		public var x:int;
		public var y:int;
		public var direction:String;
		public var world:World;
		public var ticks:int;
		
		public function WallTrap(world:World, x:int, y:int, dir:String, ticks:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.direction = dir;
			this.ticks = ticks;
		}
		
		override public function update():void
		{
			ticks = (ticks + 1) % 3;
			if (ticks == 0)
				Main.addAnimation(new Arrow(world, x, y, direction));
		}
	}
}