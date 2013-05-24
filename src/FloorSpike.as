package
{
	public class FloorSpike implements Animation
	{
		public var world:World;
		public var effect:Object;
		public var ticks:int = 0;
		
		private var _done:Boolean = false;
		
		public function get done():Boolean { return _done; };
		
		public function FloorSpike(world:World, x:int, y:int) 
		{
			this.world = world;
			this.effect = new FloorSpikeEffect(x, y);
			
			world.addAnimationEffect(effect);
		}
		
		public function update():void
		{
			ticks++;
			
			if (ticks > 9)
			{
				var hit:Player = world.getCreatureAt(effect.x, effect.y);
				if (hit != null)
					hit.takeDamage(10);
				
				_done = true;
				world.removeAnimationEffect(effect);
			}
		}
	}
}