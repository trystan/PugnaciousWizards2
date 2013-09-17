package themes
{
	import flash.geom.Point;
	
	public class GuardRoom implements RoomTheme
	{
		public function get name():String { return "Guard room"; }
		
		public function apply(room:Room, world:World):void
		{
			var max:int = CurrentGameVariables.guardCount * (room.distance / 8) + 1;
			if (Math.random() < CurrentGameVariables.rarePercent)
				max *= 2;
				
			var tries:int = 0;
			while (tries++ < max)
			{
				var px:int = Math.random() * 7 + 1;
				var py:int = Math.random() * 7 + 1;
				
				if (world.getTile(room.worldPosition.x + px, room.worldPosition.y + py).blocksMovement)
					continue;
				
				world.addCreature(new Guard(new Point(room.worldPosition.x + px, room.worldPosition.y + py)));
			}
		}
	}
}