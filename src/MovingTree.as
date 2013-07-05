package  
{
	import flash.geom.Point;
	import knave.Dijkstra;
	
	public class MovingTree extends Creature
	{
		public var path:Array = [];
		
		public function MovingTree(position:Point)
		{
			super(position, "Tree",
				"A tree that runs around smashing stuff.");
			
			maxHealth = 5 * 6;
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
			path = Dijkstra.pathTo(position, 
					function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement },
					function (x:int, y:int):Boolean { 
						var c:Creature = world.getCreature(x, y);
						return c != null && c != this && canSeeCreature(c) && type != c.type; 
					} );
		}
		
		override public function die():void 
		{
		}
		
		override public function bleed(amount:int):void 
		{
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