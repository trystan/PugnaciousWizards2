package animations
{
	public class FloorSpike implements Animation
	{
		public function get x():int { return _x; }
		public function get y():int { return _y; }
		public function get direction():String { return ""; }
		
		public var _x:int;
		public var _y:int;
		public var world:World;
		public var ticks:int = 0;
		
		private var _done:Boolean = false;
		
		public function get done():Boolean { return _done; };
		
		public function FloorSpike(world:World, x:int, y:int) 
		{
			this._x = x;
			this._y = y;
			this.world = world;
			
			world.addAnimationEffect(this);
		}
		
		public function update():void
		{
			ticks++;
			
			if (ticks > 3)
			{
				var hit:Creature = world.getCreature(x, y);
				if (hit != null)
					hit.hurt(10, "You've been impailed on a spike in the floor.");
				
				_done = true;
			}
		}
	}
}