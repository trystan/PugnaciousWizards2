package  
{
	import flash.geom.Point;
	
	public class Player 
	{
		public var position:Point;
		public var world:World;
		
		public function Player(position:Point) 
		{
			this.position = position;
		}
		
		public function moveBy(x:Number, y:Number):void 
		{
			if (world.blocksMovement(position.x + x, position.y + y))
				return;
				
			position.x += x;
			position.y += y;
		}
	}
}