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
					row.push(false);
				seen.push(row);
			}
		}
		
		public function hasSeen(x:int, y:int):Boolean
		{
			return seen[x][y];
		}
		
		public function canSee(x:int, y:int):Boolean
		{
			var visible:Boolean = Math.abs(viewer.position.x - x) < 11 && Math.abs(viewer.position.y - y) < 11;
			
			if (!visible)
				return false;
				
			visible = (viewer.position.x - x)*(viewer.position.x - x) + (viewer.position.y - y)*(viewer.position.y - y) < 121;
			
			if (!visible)
				return false;
			
			for each (var p:Point in Line.betweenCoordinates(viewer.position.x, viewer.position.y, x, y).points)
			{
				if (viewer.world.getTile(p.x, p.y).blocksVision && !(p.x == x && p.y == y))
					return false;
			}
			
			seen[x][y] = true;
			
			return true;
		}
	}
}