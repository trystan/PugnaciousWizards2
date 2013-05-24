package
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	
	public class Arrow implements Animation
	{
		public var x:int;
		public var y:int;
		public var direction:String;
		public var world:World;
		public var ticks:int;
		
		private var _done:Boolean = false;
		public function get done():Boolean { return _done; };
		
		public function Arrow(world:World, x:int, y:int, dir:String) 
		{
			this.x = x;
			this.y = y;
			this.world = world;
			this.direction = dir;
			this.ticks = 0;
			
			world.addAnimationEffect(this);
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
			
			var hit:Player = world.getCreatureAt(x, y);
			if (hit != null)
			{
				hit.takeDamage(5);
				_done = true;
				world.removeAnimationEffect(this);	
			}
			else if (world.getTile(x, y).blocksArrows)
			{
				_done = true;
				world.removeAnimationEffect(this);
			}
		}
	}
}