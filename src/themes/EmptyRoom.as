package themes
{
	import flash.geom.Point;
	
	public class EmptyRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			while (Math.random() < 0.66)
			{
				var px:int = Math.random() * 7 + 1;
				var py:int = Math.random() * 7 + 1;
				
				if (world.getTile(room.worldPosition.x + px, room.worldPosition.y + py).blocksMovement)
					continue;
					
				world.add(new Guard(new Point(room.worldPosition.x + px, room.worldPosition.y + py)));
			}
		}
	}
}