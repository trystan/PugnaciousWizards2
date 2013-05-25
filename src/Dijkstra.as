// https://gist.github.com/trystan/4968958
package  
{
	import flash.geom.Point;
	
	public class Dijkstra 
	{
		private var grid:Array;
		
		public function Dijkstra(w:int, h:int)
		{
			grid = makeGrid(w, h);
		}
		
		private function makeGrid(w:int, h:int):Array 
		{
			var grid:Array = [];
			for (var x:int = 0; x < w; x++)
			{
				var row:Array = [];
				for (var y:int = 0; y < h; y++)
					row.push(null);
				grid.push(row);
			}
			return grid;
		}
		
		private function makePath(endNode:Point):Array 
		{
			var path:Array = [];
			while (grid[endNode.x][endNode.y] != endNode)
			{
				path.push(endNode);
				endNode = grid[endNode.x][endNode.y];
			}
			path.push(endNode);
			path.reverse();
			return path;
		}
		
		public function pathTo(start:Point, canEnter:Function, check:Function):Array
		{
			var open:Array = [new Point(start.x, start.y)];
			grid[start.x][start.y] = open[0];
			
			while (open.length > 0)
			{
				var current:Point = open[0];
				open.splice(0, 1);
				
				if (check(current.x, current.y))
					return makePath(current);
				
				for each (var offset:Array in [[-1,0],[0,-1],[0,1],[1,0],[-1,-1],[-1,1],[1,-1],[1,1]])
				{
					var neighbor:Point = new Point(current.x + offset[0], current.y + offset[1]);
					
					if (neighbor.x < 0 
                                           || neighbor.y < 0 
                                           || neighbor.x >= grid.length 
                                           || neighbor.y >= grid[0].length)
						continue;
						
					if (grid[neighbor.x][neighbor.y] != null)
						continue;
					
					grid[neighbor.x][neighbor.y] = current;
					
					if (check(neighbor.x, neighbor.y))
						return makePath(neighbor);
					
					if (!canEnter(neighbor.x, neighbor.y))
						continue;
					
					open.push(neighbor);
				}
			}
			return [];
		}
		
		public static function pathTo(start:Point, canEnter:Function, check:Function):Array
		{
			return new Dijkstra(80, 80).pathTo(start, canEnter, check);
		}
	}
}