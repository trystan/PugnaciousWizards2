package themes
{
	import flash.geom.Point;
	
	public class TreasureRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			if (Math.random() < 0.05)
				bigTreasure(room, world);
			else
				normalTreasure(room, world);
		}
		
		private function normalTreasure(room:Room, world:World):void 
		{
			world.addItem(room.worldPosition.x + 3, room.worldPosition.y + 3, new HealthContainer());
		}
		
		private function bigTreasure(room:Room, world:World):void 
		{
			world.addItem(room.worldPosition.x + 2, room.worldPosition.y + 2, new HealthContainer());
			world.addItem(room.worldPosition.x + 2, room.worldPosition.y + 4, new HealthContainer());
			world.addItem(room.worldPosition.x + 4, room.worldPosition.y + 4, new HealthContainer());
			world.addItem(room.worldPosition.x + 4, room.worldPosition.y + 2, new HealthContainer());
		}
	}
}