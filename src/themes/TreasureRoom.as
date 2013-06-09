package themes
{
	import flash.geom.Point;
	
	public class TreasureRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			world.addItem(room.worldPosition.x + 3, room.worldPosition.y + 3, new HealthContainer());
		}
	}
}