package  
{
	import flash.utils.Dictionary;
	
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
			return seen[x][y] == true;
		}
		
		public function canSee(x:int, y:int):Boolean
		{
			var visible:Boolean = (viewer.position.x - x)*(viewer.position.x - x) + (viewer.position.y - y)*(viewer.position.y - y) < 121;
			
			if (visible)
				seen[x][y] = true;
			
			return visible;
		}
	}
}