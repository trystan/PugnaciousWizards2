package  
{
	public class World 
	{
		private var walls:Array = [];
		
		public function add(player:Player):void
		{
			player.world = this;
		}
		
		public function blocksMovement(x:int, y:int):Boolean
		{
			return isOutOfBounds(x, y) || isWall(x, y);
		}
		
		public function addWall(x:int, y:int):void 
		{
			walls.push(x + "," + y);
		}
		
		public function isWall(x:int, y:int):Boolean
		{
			return walls.indexOf(x + "," + y) > -1;
		}
		
		private function isOutOfBounds(x:int, y:int):Boolean 
		{
			return x < 0 || y < 0 || x > 79 || y > 79;
		}
	}
}