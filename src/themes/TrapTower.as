package themes
{
	import features.TowerTrap;
	
	public class TrapTower implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			for (var i:int = 0; i < (int)(room.distance / 6 + 1); i++)
			{
				var px:int = Math.random() * 5 + 6;
				var py:int = Math.random() * 5 + 6;
				
				world.addEffect(new TowerTrap(world, room.position.x * 8 + px, room.position.y * 8 + py));
			}
		}
	}
}