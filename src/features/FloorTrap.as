package features
{
	import animations.FloorSpike;
	import flash.geom.Point;
	
	public class FloorTrap extends CastleFeature
	{
		public var world:World;
		public var triggers:Array;
		
		public function FloorTrap(world:World, triggers:Array) 
		{
			this.world = world;
			this.triggers = triggers;
		}
		
		override public function contains(x:int, y:int):Boolean
		{
			return triggers.filter(function (p:Point, i:int, a:Array):Boolean {
				return p.x == x && p.y == y;
			}).length > 0;
		}
		
		override public function update():void
		{
			for each (var p:Point in triggers)
			{
				if (world.getCreature(p.x, p.y) == null)
					continue;
				
				activiate();
				return;
			}
		}
		
		private function activiate():void
		{
			for each (var p:Point in triggers)
				new FloorSpike(world, p.x, p.y);
		}
	}
}