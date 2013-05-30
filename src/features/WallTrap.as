package features
{
	import animations.Arrow;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class WallTrap extends CastleFeature
	{
		public var sources:Array;
		public var direction:String;
		public var world:World;
		public var ticks:int;
		public var payload:Payload;
		
		public function WallTrap(world:World, sources:Array, dir:String, ticks:int, payload:Payload) 
		{
			this.world = world;
			this.sources = sources;
			this.direction = dir;
			this.ticks = ticks;
			this.payload = payload;
		}
		
		override public function update():void
		{
			ticks = (ticks + 1) % 3;
			if (ticks > 0)
				return;
			
			for each (var p:Point in sources)
				Main.addAnimation(new Arrow(world, p.x, p.y, direction, payload));
		}
	}
}