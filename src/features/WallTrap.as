package features
{
	import animations.Arrow;
	import flash.geom.Point;
	import payloads.Ice;
	import payloads.Payload;
	
	public class WallTrap extends CastleFeature
	{
		public var sources:Array;
		public var direction:String;
		public var world:World;
		public var ticks:int;
		public var payload:Payload;
		public var howOften:int;
		
		public function WallTrap(world:World, sources:Array, dir:String, ticks:int, payload:Payload, howOften:int) 
		{
			this.world = world;
			this.sources = sources;
			this.direction = dir;
			this.ticks = ticks;
			this.payload = payload;
			this.howOften = howOften;
		}
		
		override public function retheme(payload:Payload):void
		{
			if (payload is Ice)
				howOften = 3;
				
			this.payload = payload;
		}
		
		override public function update():void
		{
			ticks = (ticks + 1) % howOften;
			if (ticks > 0)
				return;
			
			for each (var p:Point in sources)
				new Arrow(world, p.x, p.y, direction, payload);
		}
	}
}