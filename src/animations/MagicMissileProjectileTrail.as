package animations 
{
	public class MagicMissileProjectileTrail implements Animation
	{
		public function get x():int { return _x; }
		public function get y():int { return _y; }
		public function get direction():String { return _direction; }
		
		public var _x:int;
		public var _y:int;
		public var ticks:int;
		public var world:World;
		public var _direction:String;
		
		public function MagicMissileProjectileTrail(world:World, x:int, y:int, direction:String, ticks:int) 
		{
			this.world = world;
			this._x = x;
			this._y = y;
			this.ticks = ticks;
			this._direction = direction;
			
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