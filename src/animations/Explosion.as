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
		public var max:int = 7 * 7;
		
		public function Explosion(world:World, x:int, y:int) 
		{
			this.world = world;
			this.frontiers = [new Point(x, y)];
			this.occupied.push(x + "," + y);
			
			world.addAnimationEffect(this);
		}
		
		public function get done():Boolean 
		{
			return tiles.length > max || frontiers.length == 0;
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
				var creature:Creature = world.getCreatureAt(p.x, p.y);
				if (creature != null)
					creature.burn(6);
			}
		}
		
		private function spread():void 
		{
			while (frontiers.length > 0)
			{
				var p:Point = frontiers.shift();
				
				if (Math.random() < 0.9)
					spreadTo(new Point(p.x, p.y - 1));
				if (Math.random() < 0.9)
					spreadTo(new Point(p.x, p.y + 1));
				if (Math.random() < 0.9)
					spreadTo(new Point(p.x - 1, p.y));
				if (Math.random() < 0.9)
					spreadTo(new Point(p.x + 1, p.y));
				
				if (Math.random() < 0.2)
					spreadTo(new Point(p.x - 1, p.y - 1));
				if (Math.random() < 0.2)
					spreadTo(new Point(p.x + 1, p.y + 1));
				if (Math.random() < 0.2)
					spreadTo(new Point(p.x - 1, p.y + 1));
				if (Math.random() < 0.2)
					spreadTo(new Point(p.x + 1, p.y - 1));
			}
			while (next.length > 0)
				frontiers.push(next.shift());
		}
		
		private function spreadTo(n:Point):void 
		{
			if (tiles.length > max || occupied.indexOf(n.x + "," + n.y) > -1)
				return;
				
			if (world.getTile(n.x, n.y).burnChance > 0)
				world.addFeature(new BurningFire(world, n.x, n.y));
				
			if (world.getTile(n.x, n.y).blocksArrows)
				return;
				
			tiles.push(n);
			next.push(n);
			occupied.push(n.x + "," + n.y);
		}
	}
}