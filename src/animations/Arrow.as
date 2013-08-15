package animations
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class Arrow implements Animation
	{
		public function get x():int { return _x; }
		public function get y():int { return _y; }
		public function get direction():String { return _direction; }
		
		public var _x:int;
		public var _y:int;
		public var _direction:String;
		public var world:World;
		public var ticks:int;
		public var payload:Payload;
		
		private var _done:Boolean = false;
		public function get done():Boolean { return _done; };
		
		public function Arrow(world:World, x:int, y:int, dir:String, payload:Payload) 
		{
			this._x = x;
			this._y = y;
			this.world = world;
			this._direction = dir;
			this.ticks = 0;
			this.payload = payload;
			
			world.addAnimationEffect(this);
			
			update();
		}
		
		public function update():void
		{
			for (var i:int = 0; i < direction.length; i++)
			{
				switch (direction.charAt(i))
				{
					case "N": _y++; break;
					case "S": _y--; break;
					case "W": _x++; break;
					case "E": _x--; break;
				}
			}
			
			hit();
		}
		
		private function hit():void
		{
			var creature:Creature = world.getCreature(x, y);
			if (creature != null)
			{
				_done = true;
				payload.hitCreature(creature);
			}
			else if (world.getTile(x, y, true).blocksArrows)
			{
				_done = true;
				payload.hitTile(world, x, y);
			}
		}
	}
}