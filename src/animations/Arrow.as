package animations
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class Arrow implements Animation
	{
		public var x:int;
		public var y:int;
		public var direction:String;
		public var world:World;
		public var ticks:int;
		public var payload:Payload;
		
		private var _done:Boolean = false;
		public function get done():Boolean { return _done; };
		
		public function Arrow(world:World, x:int, y:int, dir:String, payload:Payload) 
		{
			this.x = x;
			this.y = y;
			this.world = world;
			this.direction = dir;
			this.ticks = 0;
			this.payload = payload;
			
			world.addAnimationEffect(this);
			
			hit();
		}
		
		public function update():void
		{
			for (var i:int = 0; i < direction.length; i++)
			{
				switch (direction.charAt(i))
				{
					case "N": y++; break;
					case "S": y--; break;
					case "W": x++; break;
					case "E": x--; break;
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
			else if (world.getTile(x, y).blocksArrows)
			{
				_done = true;
				payload.hitTile(world, x, y);
			}
		}
	}
}