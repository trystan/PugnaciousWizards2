package  
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import knave.Line;
	
	public class SimpleLineOfSight 
	{
		private static var VISIBLE:int = 0, NOT_VISIBLE:int = 1, UNKNOWN:int = 2;
		
		private var seen:Array;
		private var currentlySeen:Array;
		private var viewer:Creature;
		
		public function SimpleLineOfSight(viewer:Creature) 
		{
			this.viewer = viewer;
			seen = grid(Tile.out_of_bounds);
			currentlySeen = grid(UNKNOWN);
		}
		
		private function grid(defaultValue:Object):Array
		{
			var arr:Array = [];
			for (var x:int = 0; x < 80; x++)
			{				
				var row:Array = [];
				for (var y:int = 0; y < 80; y++)
					row.push(defaultValue);
				arr.push(row);
			}
			return arr;
		}
		
		public function update():void
		{
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				currentlySeen[x][y] = UNKNOWN;
		}
		
		public function see(x:int, y:int):void
		{
			var tile:Tile = viewer.world.getTile(x, y);
			
			if (tile != Tile.out_of_bounds)
				seen[x][y] = tile;
		}
		
		public function remembered(x:int, y:int):Tile
		{
			return seen[x][y];
		}
		
		public function hasSeen(x:int, y:int):Boolean
		{
			return seen[x][y] != Tile.out_of_bounds;
		}
		
		public function canSee(x:int, y:int):Boolean
		{
			if (x < 0 || y < 0 || x > 79 || y > 79)
				return false;
				
			if (currentlySeen[x][y] == UNKNOWN)
				check(x, y);
				
			return currentlySeen[x][y] == VISIBLE;
		}
		
		private function check(x:int, y:int):void
		{
			var r:int = Math.max(1, viewer.visionRadius);
			
			if (Math.abs(viewer.position.x - x) > r || Math.abs(viewer.position.y - y) > r)
			{
				currentlySeen[x][y] = NOT_VISIBLE;
				return;
			}
			
			if ((viewer.position.x - x) * (viewer.position.x - x) + (viewer.position.y - y) * (viewer.position.y - y) >= r * r)
			{
				currentlySeen[x][y] = NOT_VISIBLE;
				return;
			}
			
			for each (var p:Point in Line.betweenCoordinates(viewer.position.x, viewer.position.y, x, y).points)
			{
				if (currentlySeen[x][y] != UNKNOWN)
					return;
					
				if (viewer.world.getTile(p.x, p.y).blocksVision && !(p.x == x && p.y == y))
				{
					currentlySeen[x][y] = NOT_VISIBLE;
					return;
				}
			}
			
			var tile:Tile = viewer.world.getTile(x, y);
			
			if (tile == Tile.out_of_bounds)
			{
				currentlySeen[x][y] = NOT_VISIBLE;
				return;
			}
			
			if (tile.remember)
				seen[x][y] = tile;
			
			currentlySeen[x][y] = VISIBLE;
		}
	}
}