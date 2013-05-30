package themes
{
	import features.RotatingTowerTrap;
	
	public class RotatingTrapTower implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			for (var i:int = 0; i < (int)(room.distance / 6 + 1); i++)
			{
				var px:int = Math.random() * 5 + 6;
				var py:int = Math.random() * 5 + 6;
				
				world.addFeature(new RotatingTowerTrap(world, room.position.x * 8 + px, room.position.y * 8 + py));
			}
		}
	}
}