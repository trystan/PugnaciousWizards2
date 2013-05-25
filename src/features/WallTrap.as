package features
{
	import animations.Arrow;
	import payloads.Payload;
	
	public class WallTrap extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var direction:String;
		public var world:World;
		public var ticks:int;
		public var payload:Payload;
		
		public function WallTrap(world:World, x:int, y:int, dir:String, ticks:int, payload:Payload) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.direction = dir;
			this.ticks = ticks;
			this.payload = payload;
		}
		
		override public function update():void
		{
			ticks = (ticks + 1) % 3;
			if (ticks == 0)
				Main.addAnimation(new Arrow(world, x, y, direction, payload));
		}
	}
}