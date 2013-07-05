package animations 
{
	public class PullAndFreezeProjectileTrail implements Animation
	{
		public var x:int;
		public var y:int;
		public var ticks:int;
		public var world:World;
		
		public function PullAndFreezeProjectileTrail(world:World, x:int, y:int, ticks:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.ticks = ticks;
			
			world.addAnimationEffect(this);
		}
		
		public function get done():Boolean 
		{
			return ticks < 1;
		}
		
		public function update():void 
		{
			ticks--;
		}
	}
}