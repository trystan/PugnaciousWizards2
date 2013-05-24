package animations
{
	public class FloorSpike implements Animation
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var ticks:int = 0;
		
		private var _done:Boolean = false;
		
		public function get done():Boolean { return _done; };
		
		public function FloorSpike(world:World, x:int, y:int) 
		{
			this.x = x;
			this.y = y;
			this.world = world;
			
			world.addAnimationEffect(this);
		}
		
		public function update():void
		{
			ticks++;
			
			if (ticks > 9)
			{
				var hit:Player = world.getCreatureAt(x, y);
				if (hit != null)
					hit.takeDamage(10);
				
				_done = true;
				world.removeAnimationEffect(this);
			}
		}
	}
}