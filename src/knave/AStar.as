package knave 
{
	import flash.geom.Point;

	public class AStar
	{
		private var open:Array = null;
		private var closed:Array = null;
		
		public var offsets:Array = [[ -1, 0], [0, -1], [0, 1], [1, 0], [ -1, -1], [ -1, 1], [1, -1], [1, 1]];
		
		private var canEnter:Function;
		private var start:Point;
		private var checkEnding:Boolean;
		
		public function AStar(canEnter:Function, start:Point, checkEnding:Boolean)
		{
			this.canEnter = canEnter;
			this.start = start;
			this.checkEnding = checkEnding;
		}
		
		public function pathTo(end:Point):Array
		{	
			if((checkEnding && !canEnter(end.x, end.y)) || (start.x == end.x && start.y == end.y))
				return [];
			
			var startNode:AStarNode = new AStarNode(start.x, start.y, null);
			startNode.g = 0;
			startNode.h = getHCost(start, end);
			startNode.f = startNode.g + startNode.h;
				
			open = [startNode];
			closed = [];
			
			while(open.length > 0)
			{
				var current:AStarNode = open[0];
				
				closed.push(current);
				open.splice(0,1);
				
				if(current.x == end.x && current.y == end.y)
					break;
																			
				for each (var offset:Array in offsets)
				{
					var neighbor:Point = new Point(current.x + offset[0], current.y + offset[1]);
					
					var newG:int = getGCost(current, neighbor);
					
					if (!checkEnding && neighbor.x == end.x && neighbor.y == end.y)
					{
						var endNode:AStarNode = new AStarNode(neighbor.x, neighbor.y, current);
						endNode.g = newG;
						endNode.h = getHCost(neighbor, end);
						endNode.f = endNode.g + endNode.h;
						open.unshift(endNode);
						break;
					}
					
					if (!canEnter(neighbor.x, neighbor.y) || getFromList(closed, neighbor) != null)
						continue;
					
					var visited:AStarNode = getFromList(open, neighbor);
					
					if(visited == null)
					{
						var newNode:AStarNode = new AStarNode(neighbor.x, neighbor.y, current);
						newNode.g = newG;
						newNode.h = getHCost(neighbor, end);
						newNode.f = newNode.g + newNode.h;
						open.push(newNode);
					}
					else if(newG < visited.g)
					{
						visited.parentNode = current;
						visited.g = newG;
						visited.f = visited.g + visited.h;
					}
				}
				
				open.sort(sortOnFCost);
			}
			
			return walkBackToStart(end);
		}
		
		private function walkBackToStart(end:Point):Array
		{
			var thisStep:AStarNode = getFromList(closed, end);
			if (thisStep == null)
				return [];
			
			var steps:Array = [];
			while(thisStep.x != start.x || thisStep.y != start.y)
			{
				steps.push(new Point(thisStep.x, thisStep.y));
				thisStep = thisStep.parentNode;
			}
			
			steps.reverse();
			return steps;
		}
		
		private function getGCost(from:Point, to:Point):int
		{
			return Math.max(Math.abs(from.x - to.x), Math.abs(from.y - to.y));
		}
		
		private function getHCost(from:Point, to:Point):int
		{
			return (Math.abs(from.x - to.x) + Math.abs(from.y - to.y)) / 2
		}
		
		private function getFromList(list:Array, loc:Point):AStarNode
		{
			for each (var other:AStarNode in list)
			{
				if (other.x == loc.x && other.y == loc.y)
					return other;
			}
			return null;
		}
		
		private function sortOnFCost(n1:AStarNode, n2:AStarNode):Number
		{
			if (n1.f < n2.f)
				return -1;
			else if (n1.f > n2.f)
				return 1;
			else
				return 0;
		}
		
		public static function pathTo(canEnter:Function, start:Point, end:Point, checkEnding:Boolean):Array 
		{
			return new AStar(canEnter, start, checkEnding).pathTo(end);
		}
	}
}

class AStarNode extends flash.geom.Point
{
	public var g:int = 0;
	public var h:int = 0;
	public var f:int = 0;
	public var parentNode:AStarNode = null;
	
	public function AStarNode(x:int, y:int, parent:AStarNode)
	{
		super(x, y);
		this.parentNode = parent;
	}
}