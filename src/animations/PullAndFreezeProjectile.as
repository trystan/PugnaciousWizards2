package animations
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class PullAndFreezeProjectile implements Animation
	{
		public function get x():int { return _x; }
		public function get y():int { return _y; }
		public function get direction():String { return _direction; }
		
		public var _x:int;
		public var _y:int;
		public var vx:int;
		public var vy:int;
		public var world:World;
		public var ticks:int;
		public var _direction:String;
		
		private var _done:Boolean = false;
		public function get done():Boolean { return _done; }
		
		public function PullAndFreezeProjectile(world:World, x:int, y:int, vx:int, vy:int, ticks:int = 14) 
		{
			this._x = x;
			this._y = y;
			this.vx = vx;
			this.vy = vy;
			this.world = world;
			this.ticks = ticks;
			
			this._direction = "";
			
			if (vy < 0)
				this._direction += "N";
			else if (vy > 0)
				this._direction += "S";
				
			if (vx < 0)
				this._direction += "W";
			else if (vx > 0)
				this._direction += "E";
				
			world.addAnimationEffect(this);
		}
		
		public function update():void
		{
			ticks--;
			
			if (!(vx == 0 && vy == 0) && !world.getTile(x, y).blocksMovement)
			{
				new PullAndFreezeProjectileTrail(world, x, y, 6);
			}
			
			_x += vx;
			_y += vy;
			
			if (ticks < 1)
			{
				_done = true;
				return;
			}
			
			var creature:Creature = world.getCreature(x, y);
			if (creature != null)
			{
				_done = true;
				world.addAnimationEffect(new PullAndFreezeExpansion(world, x, y));
			}
			else if (world.getTile(x, y).blocksArrows)
			{
				_done = true;
				world.addAnimationEffect(new PullAndFreezeExpansion(world, x - vx, y - vy));
			}
		}
	}
}