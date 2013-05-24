package
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	
	public class Arrow implements Animation
	{
		public var direction:String;
		public var world:World;
		public var ticks:int;
		public var effect:ArrowEffect;
		
		private var _done:Boolean = false;
		public function get done():Boolean { return _done; };
		
		public function Arrow(world:World, x:int, y:int, dir:String) 
		{
			this.world = world;
			this.direction = dir;
			this.ticks = 0;
			this.effect = new ArrowEffect(x, y, direction);
			
			world.addAnimationEffect(effect);
		}
		
		public function update():void
		{
			for (var i:int = 0; i < direction.length; i++)
			{
				switch (direction.charAt(i))
				{
					case "N": effect.y++; break;
					case "S": effect.y--; break;
					case "W": effect.x++; break;
					case "E": effect.x--; break;
				}
			}
			
			if (world.getTile(effect.x, effect.y).blocksArrows)
			{
				_done = true;
				world.removeAnimationEffect(effect);
			}
		}
	}
}