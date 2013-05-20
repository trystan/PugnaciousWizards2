package  
{
	public class RoomTheme_circle implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			world.addWall(room.position.x * 8 + 5, room.position.y * 8 + 5);
			world.addWall(room.position.x * 8 + 11, room.position.y * 8 + 5);
			world.addWall(room.position.x * 8 + 11, room.position.y * 8 + 11);
			world.addWall(room.position.x * 8 + 5, room.position.y * 8 + 11);
		}
	}
}