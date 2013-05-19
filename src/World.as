package  
{
	public class World 
	{
		public function add(player:Player):void
		{
			player.world = this;
		}
		
		public function blocksMovement(x:int, y:int):Boolean
		{
			return x < 0 || y < 0 || x > 79 || y > 79;
		}
	}
}