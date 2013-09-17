package themes
{
	import flash.geom.Point;
	
	public class EmptyRoom implements RoomTheme
	{
		public function get name():String { return "Empty room"; }
		
		public function apply(room:Room, world:World):void
		{
			if (Math.random() < CurrentGameVariables.rarePercent)
			{
				for (var x:int = 0; x < 7; x++)
				for (var y:int = 0; y < 7; y++)
				{
					if (world.getTile(room.worldPosition.x + x, room.worldPosition.y + y).blocksMovement)
						continue;
					
					var existing:Creature = world.getCreature(room.worldPosition.x + x, room.worldPosition.y + y);
					
					if (existing != null)
						world.removeCreature(existing);
						
					world.addCreature(new Skeleton(new Creature(new Point(room.worldPosition.x + x, room.worldPosition.y + y), "ancient skeleton", "This thing has been dead for so long that you can't even tell what it used to be.")));
				}
			}
		}
	}
}