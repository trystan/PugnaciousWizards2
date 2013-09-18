package animations
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class TelekeneticMovement implements Animation
	{
		public function get x():int { return _x; }
		public function get y():int { return _y; }
		public function get direction():String { return ""; }
		
		public var _x:int;
		public var _y:int;
		public var dx:int;
		public var dy:int;
		public var caster:Creature;
		public var world:World;
		public var ticks:int;
		public var thing:Object;
		
		private var _done:Boolean = false;
		public function get done():Boolean { return _done; };
		
		public function TelekeneticMovement(caster:Creature, world:World, x:int, y:int, dx:int, dy:int, thing:Object) 
		{
			this._x = x;
			this._y = y;
			this.caster = caster;
			this.world = world;
			this.dx = dx;
			this.dy = dy;
			this.ticks = 0;
			this.thing = thing;
			
			world.addAnimationEffect(this);
			
			update();
		}
		
		public function update():void
		{
			if (thing is Creature)
				throwCreature(thing as Creature);
			else if (thing is Item)
				throwItem(thing as Item);
				
			if (ticks++ == 9)
				_done = true;
		}
		
		private function throwCreature(c:Creature):void 
		{
			if (!caster.world.getTile(c.position.x + dx, c.position.y + dy, true).blocksMovement
					&& caster.world.getCreature(c.position.x + dx, c.position.y + dy) == null)
			{
				c.position.x += dx;
				c.position.y += dy;
			}
			else
			{
				c.hurt(6, "Telekenetically slammed into a " + caster.world.getTile(c.position.x + dx, c.position.y + dy, true).name + ".");
				c.bleed(2);
				_done = true;
			}
		}
		
		private function throwItem(i:Item):void 
		{
			caster.world.removeItem(i);
			if (!caster.world.getTile(x + dx, y + dy, true).blocksArrows)
			{
				_x += dx;
				_y += dy;
				
				var other:Creature = caster.world.getCreature(x, y);
				if (other == caster)
				{
					if (i.canBePickedUpBy(caster))
					{
						i.getPickedUpBy(caster);
						caster.world.removeItem(i);
					}
					else
					{
						_x -= dx;
						_y -= dy;
						caster.world.addItem(x, y, i);
					}
					_done = true;
					return;
				}
				else if (other != null)
				{
					other.hurt(5, "Hit by a flying " + i.name + ".");
					other.bleed(2);
				}
			}
			if (!_done)
				caster.world.addItem(x, y, i);
		}
	}
}