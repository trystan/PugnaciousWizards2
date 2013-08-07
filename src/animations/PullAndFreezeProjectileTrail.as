package animations 
{
	public class PullAndFreezeProjectileTrail implements Animation
	{
		public function get x():int { return _x; }
		public function get y():int { return _y; }
		public function get direction():String { return ""; }
		
		public var _x:int;
		public var _y:int;
		public var ticks:int;
		public var world:World;
		
		public function PullAndFreezeProjectileTrail(world:World, x:int, y:int, ticks:int) 
		{
			this.world = world;
			this._x = x;
			this._y = y;
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