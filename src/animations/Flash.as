package animations 
{
	import features.BurningFire;
	import flash.geom.Point;
	
	public class Flash implements Animation
	{
		public var world:World;
		public var x:int;
		public var y:int;
		public var ticks:int;
		
		public function Flash(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.ticks = 0;
			
			world.addAnimationEffect(this);
		}
		
		public function update():void 
		{
			ticks++;
		}
		
		public function get done():Boolean 
		{
			return ticks > 2;
		}
	}
}