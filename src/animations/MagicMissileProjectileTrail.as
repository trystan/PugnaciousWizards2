package animations 
{
	public class MagicMissileProjectileTrail implements Animation
	{
		public var x:int;
		public var y:int;
		public var ticks:int;
		public var world:World;
		public var direction:String;
		
		public function MagicMissileProjectileTrail(world:World, x:int, y:int, direction:String, ticks:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.ticks = ticks;
			this.direction = direction;
			
			world.addAnimationEffect(this);
		}
		
		public function get done():Boolean 
		{
			return ticks < 1;
		}
		
		public function update():void 
		{
			ticks--;
			if (ticks < 1)
			{
				world.removeAnimationEffect(this);
			}
		}
	}
}