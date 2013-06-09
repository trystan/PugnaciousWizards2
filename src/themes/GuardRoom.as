package themes
{
	import flash.geom.Point;
	
	public class GuardRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			var max:int = room.distance / 7 + 1;
			if (Math.random() < Globals.rarePercent)
				max *= 2;
				
			var tries:int = 0;
			while (tries++ < max)
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