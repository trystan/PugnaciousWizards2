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
			position.x += x;
			position.y += y;
		}
	}
}