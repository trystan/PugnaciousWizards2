package  
{
	public class RoomTheme_randomPillars implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			do
			{
				var px:int = Math.random() * 5 + 6;
				var py:int = Math.random() * 5 + 6;
				world.addWall(room.position.x * 8 + px, room.position.y * 8 + py);
			}
			while (Math.random() < 0.66)
		}
	}
}