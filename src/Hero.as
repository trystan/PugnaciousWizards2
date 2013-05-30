package  
{
	import flash.geom.Point;
	
	public class Hero extends Player
	{
		private var path:Array = [];
		
		public function Hero(position:Point)
		{
			super(position);
		}
		
		public function doAi():void
		{
			if (path.length == 0)
				pathToNextTarget();
			
			if (path.length > 0)
				moveToTarget();
			else
				wanderRandomly();
		}
		
		private function pathToNextTarget():void 
		{
			if (this.hasAllEndPieces)
			{
				path = pathToEndPoint();
			}
			else
			{
				path = pathToVisibleEndPice();
					
				if (path.length == 0)
					path = pathToVisibleDoor();
			}
		}
		
		private function moveToTarget():void 
		{
			var next:Point = path.shift();
			
			moveBy(clamp(next.x - position.x), clamp(next.y - position.y));
			
			if (Math.abs(next.x - position.x) + Math.abs(next.y - position.y) > 0)
				path.unshift(next);
		}
		
		private function clamp(n:int):int
		{
			return Math.max( -1, Math.min(n, 1));
		}
		
		private function wanderRandomly():void 
		{
			moveBy((int)(Math.random() * 3) - 1, (int)(Math.random() * 3) - 1);
		}
		
		private function pathToEndPoint():Array 
		{
			return Dijkstra.pathTo(
				new Point(position.x, position.y),
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement; },
				function (x:int, y:int):Boolean { return x < 3; } );
		}
		
		private function pathToVisibleEndPice():Array 
		{
			return Dijkstra.pathTo(
				new Point(position.x, position.y),
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement && world.getTile(x, y) != Tile.door_closed; },
				function (x:int, y:int):Boolean { return world.getItem(x, y) != null; } );
		}
		
		private function pathToVisibleDoor():Array 
		{
			return Dijkstra.pathTo(
				new Point(position.x, position.y),
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement; },
				function (x:int, y:int):Boolean { return world.isClosedDoor(x, y); } );
		}
	}
}