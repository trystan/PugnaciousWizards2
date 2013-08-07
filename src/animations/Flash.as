package animations 
{
	import features.BurningFire;
	import flash.geom.Point;
	
	public class Flash implements Animation
	{
		public function get x():int { return _x; }
		public function get y():int { return _y; }
		public function get direction():String { return ""; }
		
		public var world:World;
		public var _x:int;
		public var _y:int;
		public var ticks:int;
		
		public function Flash(world:World, x:int, y:int) 
		{
			this.world = world;
			this._x = x;
			this._y = y;
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