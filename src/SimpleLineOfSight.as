package  
{
	import flash.utils.Dictionary;
	
	public class SimpleLineOfSight 
	{
		private var seen:Array = [];
		private var viewer:Player;
		
		public function SimpleLineOfSight(viewer:Player) 
		{
			this.viewer = viewer;
		}
		
		public function hasSeen(x:int, y:int):Boolean
		{
			return seen.indexOf(x + "," + y) > -1;
		}
		
		public function canSee(x:int, y:int):Boolean
		{
			var visible:Boolean = (viewer.position.x - x)*(viewer.position.x - x) + (viewer.position.y - y)*(viewer.position.y - y) < 64;
			
			if (visible && seen.indexOf(x + "," + y) == -1)
				seen.push(x + "," + y);
			
			return visible;
		}
	}
}