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
		
		public function addCastleWalls():void 
		{
			for (var x1:int = 0; x1 < 9 * 8 + 1; x1++)
			for (var y1:int = 0; y1 < 10; y1++)
				addWall(x1 + 4, y1 * 8 + 4);
				
			for (var x2:int = 0; x2 < 10; x2++)
			for (var y2:int = 0; y2 < 9 * 8 + 1; y2++)
				addWall(x2 * 8 + 4, y2 + 4);
		}
		
		private function isOutOfBounds(x:int, y:int):Boolean 
		{
			return x < 0 || y < 0 || x > 79 || y > 79;
		}
	}
}