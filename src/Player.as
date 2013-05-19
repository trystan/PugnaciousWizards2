package  
{
	import flash.geom.Point;
	
	public class Player 
	{
		public var position:Point;
		
		public function Player(position:Point) 
		{
			this.position = position;
		}
		
		public function moveBy(x:Number, y:Number):void 
		{
			if (position.x + x < 0 || position.y + y < 0 || position.x + x > 79 || position.y + y > 79)
				return;
				
			position.x += x;
			position.y += y;
		}
	}
}