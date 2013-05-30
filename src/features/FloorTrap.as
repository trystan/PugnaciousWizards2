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
		
		override public function update():void
		{
			for each (var p:Point in triggers)
			{
				if (world.getCreatureAt(p.x, p.y) == null)
					continue;
				
				activiate();
				return;
			}
		}
		
		private function activiate():void
		{
			for each (var p:Point in triggers)
				Main.addAnimation(new FloorSpike(world, p.x, p.y));
		}
	}
}