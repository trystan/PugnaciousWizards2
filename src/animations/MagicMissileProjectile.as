package animations
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class MagicMissileProjectile implements Animation
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
		
		public function MagicMissileProjectile(world:World, x:int, y:int, vx:int, vy:int, ticks:int = 14) 
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
			
			if (!(vx == 0 && vy == 0) && !world.getTile(x, y, true).blocksMovement)
				new MagicMissileProjectileTrail(world, x, y, direction, 5);
			
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
				creature.hurt(5, "You've been killed by a magic missile.");
				creature.bleed(2);
				_done = true;
				
				if (vx == 0 || vy == 0)
				{
					new MagicMissileProjectile(world, x, y, -1, 1, ticks-2);
					new MagicMissileProjectile(world, x, y, -1, -1, ticks-2);
					new MagicMissileProjectile(world, x, y, 1, -1, ticks-2);
					new MagicMissileProjectile(world, x, y, 1, 1, ticks-2);
				}
				else
				{
					new MagicMissileProjectile(world, x, y, 0, 1, ticks-2);
					new MagicMissileProjectile(world, x, y, 0, -1, ticks-2);
					new MagicMissileProjectile(world, x, y, 1, 0, ticks-2);
					new MagicMissileProjectile(world, x, y, -1, 0, ticks-2);
				}
			}
			else if (world.getTile(x, y, true).blocksArrows)
			{
				if (vx == 0 || vy == 0)
				{
					vx *= -1;
					vy *= -1;
					_x += vx;
					_y += vy;
				}
				else
				{		
					_x -= vx;
					_y -= vy;
					_done = true;
					
					switch (direction)
					{
						case "NW":
							if (!world.getTile(x, y-1, true).blocksArrows)
								new MagicMissileProjectile(world, x-1, y-1, 1, -1, ticks-1);
							if (!world.getTile(x-1, y, true).blocksArrows)
								new MagicMissileProjectile(world, x-1, y-1, -1, 1, ticks-1);
							break;
						case "NE":
							if (!world.getTile(x, y-1, true).blocksArrows)
								new MagicMissileProjectile(world, x+1, y-1, -1, -1, ticks-1);
							if (!world.getTile(x+1, y, true).blocksArrows)
								new MagicMissileProjectile(world, x+1, y-1, 1, 1, ticks-1);
							break;
							
						case "SW":
							if (!world.getTile(x, y+1, true).blocksArrows)
								new MagicMissileProjectile(world, x-1, y+1, 1, 1, ticks-1);
							if (!world.getTile(x-1, y, true).blocksArrows)
								new MagicMissileProjectile(world, x-1, y+1, -1, -1, ticks-1);
							break;
						case "SE":
							if (!world.getTile(x, y+1, true).blocksArrows)
								new MagicMissileProjectile(world, x+1, y+1, -1, 1, ticks-1);
							if (!world.getTile(x+1, y, true).blocksArrows)
								new MagicMissileProjectile(world, x+1, y+1, 1, -1, ticks-1);
							break;
					}
				}
			}
		}
	}
}