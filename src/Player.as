package  
{
	import flash.geom.Point;
	
	public class Player 
	{
		public var position:Point;
		public var world:World;
		public var endPiecesPickedUp:int = 0;
		public function get hasAllEndPieces():Boolean { return endPiecesPickedUp == 3; }
		
		public function Player(position:Point) 
		{
			this.position = position;
		}
		
		public function moveBy(x:Number, y:Number):void 
		{
			if (world.blocksMovement(position.x + x, position.y + y))
				return;
			
			if (world.isClosedDoor(position.x + x, position.y + y))
				world.openDoor(position.x + x, position.y + y);
			else
			{
				position.x += x;
				position.y += y;
				
				var item:EndPiece = world.getItem(position.x, position.y);
				if (item != null)
				{
					world.removeItem(position.x, position.y);
					endPiecesPickedUp++;
				}
			}
		}
	}
}