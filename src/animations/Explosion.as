package animations 
{
	import features.BurningFire;
	import flash.geom.Point;
	import payloads.Payload;
	
	public class Explosion implements Animation
	{
		public var world:World;
		public var tiles:Array = [];
		public var frontiers:Array = [];
		public var next:Array = [];
		public var occupied:Array = [];
		public var max:int = 7 * 7;
		public var payload:Payload;
		
		public function Explosion(world:World, x:int, y:int, payload:Payload, amount:int = 36, includeOrigin:Boolean = false) 
		{
			this.world = world;
			this.frontiers = [new Point(x, y)];
			this.payload = payload;
			
			if (!includeOrigin)
				this.occupied.push(x + "," + y);
				
			this.max = amount;
			
			world.addAnimationEffect(this);
		}
		
		public function get done():Boolean 
		{
			return tiles.length > max || frontiers.length == 0;
		}
		
		public function update():void 
		{
			spread();
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
			
			payload.hitTile(world, n.x, n.y);
			
			var creature:Creature = world.getCreature(n.x, n.y);
			if (creature != null)
				payload.hitCreature(creature);
					
			if (world.getTile(n.x, n.y).blocksArrows)
				return;
				
			tiles.push(n);
			next.push(n);
			occupied.push(n.x + "," + n.y);
		}
	}
}