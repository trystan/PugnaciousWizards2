package animations 
{
	import features.BurningFire;
	import flash.geom.Point;
	
	public class Explosion implements Animation
	{
		public var world:World;
		public var tiles:Array = [];
		public var frontiers:Array = [];
		public var next:Array = [];
		public var occupied:Array = [];
		
		public function Explosion(world:World, x:int, y:int) 
		{
			this.world = world;
			this.frontiers = [new Point(x, y)];
			this.occupied.push(x + "," + y);
			
			world.addAnimationEffect(this);
		}
		
		public function get done():Boolean 
		{
			return tiles.length > 36 || frontiers.length == 0;
		}
		
		public function update():void 
		{
			spread();
			applyEffect();
		}
		
		private function applyEffect():void 
		{
			for each (var p:Point in tiles)
			{
				var creature:Player = world.getCreatureAt(p.x, p.y);
				if (creature != null)
					creature.burn(6);
			}
		}
		
		private function spread():void 
		{
			while (frontiers.length > 0)
			{
				var p:Point = frontiers.shift();
				
				if (world.getTile(p.x, p.y).burnChance > 0)
					world.addFeature(new BurningFire(world, p.x, p.y));
				
				spreadTo(new Point(p.x, p.y - 1));
				spreadTo(new Point(p.x, p.y + 1));
				spreadTo(new Point(p.x - 1, p.y));
				spreadTo(new Point(p.x + 1, p.y));
				
				if (Math.random() < 0.714)
					spreadTo(new Point(p.x - 1, p.y - 1));
				if (Math.random() < 0.714)
					spreadTo(new Point(p.x + 1, p.y + 1));
				if (Math.random() < 0.714)
					spreadTo(new Point(p.x - 1, p.y + 1));
				if (Math.random() < 0.714)
					spreadTo(new Point(p.x + 1, p.y - 1));
			}
			while (next.length > 0)
				frontiers.push(next.shift());
		}
		
		private function spreadTo(n:Point):void 
		{
			if (world.blocksMovement(n.x, n.y)
					|| tiles.length > 36
					|| occupied.indexOf(n.x + "," + n.y) > -1)
				return;
			
			tiles.push(n);
			next.push(n);
			occupied.push(n.x + "," + n.y);
		}
	}
}