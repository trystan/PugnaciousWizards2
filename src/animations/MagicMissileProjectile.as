package animations
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class MagicMissileProjectile implements Animation
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
		
		public function MagicMissileProjectile(world:World, x:int, y:int, vx:int, vy:int, ticks:int = 14) 
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
				new MagicMissileProjectileTrail(world, x, y, direction, 5);
			}
			
			x += vx;
			y += vy;
			
			if (ticks == 0)
			{
				_done = true;
				return;
			}
			
			var creature:Player = world.getCreatureAt(x, y);
			if (creature != null)
			{
				creature.takeDamage(5, "Killed by your own magic missile.");
				_done = true;
				
				if (vx == 0 || vy == 0)
				{
					new MagicMissileProjectile(world, x, y, -1, 1, ticks);
					new MagicMissileProjectile(world, x, y, -1, -1, ticks);
					new MagicMissileProjectile(world, x, y, 1, -1, ticks);
					new MagicMissileProjectile(world, x, y, 1, 1, ticks);
				}
				else
				{
					new MagicMissileProjectile(world, x, y, 0, 1, ticks);
					new MagicMissileProjectile(world, x, y, 0, -1, ticks);
					new MagicMissileProjectile(world, x, y, 1, 0, ticks);
					new MagicMissileProjectile(world, x, y, -1, 0, ticks);
				}
			}
			else if (world.getTile(x, y).blocksArrows)
			{
				if (vx == 0 || vy == 0)
				{
					vx *= -1;
					vy *= -1;
					x += vx;
					y += vy;
				}
				else
				{		
					x -= vx;
					y -= vy;
					_done = true;
					
					switch (direction)
					{
						case "NW":
							if (!world.getTile(x, y-1).blocksArrows)
								new MagicMissileProjectile(world, x-1, y-1, 1, -1, ticks);
							if (!world.getTile(x-1, y).blocksArrows)
								new MagicMissileProjectile(world, x-1, y-1, -1, 1, ticks);
							break;
						case "NE":
							if (!world.getTile(x, y-1).blocksArrows)
								new MagicMissileProjectile(world, x+1, y-1, -1, -1, ticks);
							if (!world.getTile(x+1, y).blocksArrows)
								new MagicMissileProjectile(world, x+1, y-1, 1, 1, ticks);
							break;
							
						case "SW":
							if (!world.getTile(x, y+1).blocksArrows)
								new MagicMissileProjectile(world, x-1, y+1, 1, 1, ticks);
							if (!world.getTile(x-1, y).blocksArrows)
								new MagicMissileProjectile(world, x-1, y+1, -1, -1, ticks);
							break;
						case "SE":
							if (!world.getTile(x, y+1).blocksArrows)
								new MagicMissileProjectile(world, x+1, y+1, -1, 1, ticks);
							if (!world.getTile(x+1, y).blocksArrows)
								new MagicMissileProjectile(world, x+1, y+1, 1, -1, ticks);
							break;
					}
				}
			}
		}
	}
}