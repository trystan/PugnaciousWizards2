package animations
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class PullAndFreezeProjectile implements Animation
	{
		public var x:int;
		public var y:int;
		public var vx:int;
		public var vy:int;
		public var world:World;
		public var ticks:int;
		public var direction:String;
		
		private var _done:Boolean = false;
		public function get done():Boolean { return _done; }
		
		public function PullAndFreezeProjectile(world:World, x:int, y:int, vx:int, vy:int, ticks:int = 14) 
		{
			this.x = x;
			this.y = y;
			this.vx = vx;
			this.vy = vy;
			this.world = world;
			this.ticks = ticks;
			
			this.direction = "";
			
			if (vy < 0)
				this.direction += "N";
			else if (vy > 0)
				this.direction += "S";
				
			if (vx < 0)
				this.direction += "W";
			else if (vx > 0)
				this.direction += "E";
				
			world.addAnimationEffect(this);
		}
		
		public function update():void
		{
			ticks--;
			
			if (!(vx == 0 && vy == 0) && !world.getTile(x, y).blocksMovement)
			{
				new PullAndFreezeProjectileTrail(world, x, y, 6);
			}
			
			x += vx;
			y += vy;
			
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
				world.addAnimationEffect(new PullAndFreezeExpansion(world, x, y));
			}
		}
	}
}