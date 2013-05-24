package  
{
	public class FloorTrap extends CastleEffect
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var ticks:int;
		
		public function FloorTrap(world:World, x:int, y:int, ticks:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.ticks = ticks;
		}
		
		override public function update():void
		{
			ticks = (ticks + 1) % 4;
			if (ticks == 0)
				Main.addAnimation(new FloorSpike(world, x, y));
		}
	}
}