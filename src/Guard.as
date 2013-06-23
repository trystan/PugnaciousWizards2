package  
{
	import flash.geom.Point;
	import knave.Dijkstra;
	
	public class Guard extends Creature
	{
		public var path:Array = [];
		
		public function Guard(position:Point)
		{
			super(position, "Guard",
				"Guards rush to fight anyone who enters the castle.");
			
			maxHealth = 5 * 4;
			_health = maxHealth;
		}
		
		public override function doAi():void
		{
			pathToNextTarget();
			
			if (path.length > 0)
				moveToTarget();
			else
				wanderRandomly();
		}
		
		private function pathToNextTarget():void
		{
			if (canSeeCreature(world.player))
				path = Dijkstra.pathTo(position, 
									function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement },
									function (x:int, y:int):Boolean { return world.player.position.x == x && world.player.position.y == y; });
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