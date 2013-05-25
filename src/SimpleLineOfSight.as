package  
{
	import flash.utils.Dictionary;
	public class SimpleLineOfSight 
	{
		private var viewer:Player;
		
		public function SimpleLineOfSight(viewer:Player) 
		{
			this.viewer = viewer;
		}
		
		public function canSee(x:int, y:int):Boolean
		{
			return Math.abs(viewer.position.x - x) + Math.abs(viewer.position.y - y) < 8;
		}
	}
}