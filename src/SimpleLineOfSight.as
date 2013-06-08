package  
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import knave.Line;
	
	public class SimpleLineOfSight 
	{
		private var seen:Array;
		private var viewer:Player;
		
		public function SimpleLineOfSight(viewer:Player) 
		{
			this.viewer = viewer;
			seen = [];
			
			for (var x:int = 0; x < 80; x++)
			{				
				var row:Array = [];
				for (var y:int = 0; y < 80; y++)
					row.push(Tile.out_of_bounds);
				seen.push(row);
			}
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
			var r:int = Math.max(1, viewer.visionRadius);
			
			if (Math.abs(viewer.position.x - x) < r && Math.abs(viewer.position.y - y) >= r)
				return false;
				
			if ((viewer.position.x - x) * (viewer.position.x - x) + (viewer.position.y - y) * (viewer.position.y - y) >= r * r)
				return false;
			
			for each (var p:Point in Line.betweenCoordinates(viewer.position.x, viewer.position.y, x, y).points)
			{
				if (viewer.world.getTile(p.x, p.y).blocksVision && !(p.x == x && p.y == y))
					return false;
			}
			
			seen[x][y] = viewer.world.getTile(x, y);
			
			return true;
		}
	}
}