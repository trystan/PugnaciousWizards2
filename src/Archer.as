package  
{
	import animations.Arrow;
	import flash.geom.Point;
	import knave.Dijkstra;
	import knave.Line;
	import payloads.Pierce;
	
	public class Archer extends Creature
	{
		public var path:Array = [];
		
		public function Archer(position:Point)
		{
			super(position, "Archer");
			
			maxHealth = 5 * 2;
			health = maxHealth;
		}
		
		public override function doAi():void
		{
			if (canShootTarget())
				shootTarget();
			else
			{
				pathToNextTarget();
			
				if (path.length > 0)
					moveToTarget();
				else
					wanderRandomly();
			}
		}
		
		private function shootTarget():void 
		{
			var dir:String = "";
			
			if (world.player.position.y < position.y)
				dir += "S";
			else if (world.player.position.y > position.y)
				dir += "N";
			
			if (world.player.position.x < position.x)
				dir += "E";
			else if (world.player.position.x > position.x)
				dir += "W";
				
			new Arrow(world, position.x, position.y, dir, new Pierce());
		}
		
		private function canShootTarget():Boolean 
		{
			if (!canSeeCreature(world.player))
				return false;
				
			if (!isInArcherLine(position, world.player.position))
				return false;
			
			for each (var point:Point in Line.betweenPoints(position, world.player.position).points)
			{
				if (world.getTile(point.x, point.y).blocksArrows)
					return false;
			}
			return true;
		}
		
		private function isInArcherLine(from:Point, to:Point):Boolean
		{
			return from.x - to.x == 0 
					|| from.y == to.y
					|| Math.abs(from.x - to.x) - Math.abs(from.y - to.y) == 0
		}
		
		private function pathToNextTarget():void
		{
			if (canSeeCreature(world.player))
				path = Dijkstra.pathTo(position, 
									function (x:int, y:int):Boolean { return !world.blocksMovement(x, y); },
									function (x:int, y:int):Boolean { 
										return world.player.position.x == x && world.player.position.y == y
											|| isInArcherLine(new Point(x, y), world.player.position); });
		}
		
		private function moveToTarget():void 
		{
			var next:Point = path.shift();
			
			moveBy(clamp(next.x - position.x), clamp(next.y - position.y));
			
			if (Math.abs(next.x - position.x) + Math.abs(next.y - position.y) > 0)
				pathToNextTarget();
			
			if (path.length == 1 && world.isOpenedDoor(path[0].x, path[0].y))
				path.shift();
		}
		
		private function clamp(n:int):int
		{
			return Math.max( -1, Math.min(n, 1));
		}
	}
}