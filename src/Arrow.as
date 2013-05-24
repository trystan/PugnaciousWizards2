package
{
	import com.headchant.asciipanel.AsciiPanel;
	public class Arrow 
	{
		public var x:int;
		public var y:int;
		public var direction:String;
		public var world:World;
		public var ticks:int;
		
		public var done:Boolean = false;
		
		public function Arrow(world:World, x:int, y:int, dir:String) 
		{
			this.x = x;
			this.y = y;
			this.world = world;
			this.direction = dir;
			this.ticks = 0;
		}
		
		private static var NS:String = String.fromCharCode(179);
		private static var WE:String = String.fromCharCode(196);
		
		public function update(terminal:AsciiPanel):void
		{
			switch (direction)
			{
				case "N": terminal.write(NS, x, y); break;
				case "S": terminal.write(NS, x, y); break;
				case "W": terminal.write(WE, x, y); break;
				case "E": terminal.write(WE, x, y); break;
			}
			
			switch (direction)
			{
				case "N": y++; break;
				case "S": y--; break;
				case "W": x++; break;
				case "E": x--; break;
			}
			
			if (world.getTile(x, y).blocksArrows)
				done = true;
		}
	}
}