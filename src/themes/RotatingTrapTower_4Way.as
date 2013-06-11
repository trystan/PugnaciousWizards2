package themes
{
	import features.RotatingTowerTrap_4Way;
	
	public class RotatingTrapTower_4Way implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			var total:int = (int)(room.distance / 6 + 1);
			
			if (Math.random() < Globals.rarePercent)
				total *= 2;
				
			for (var i:int = 0; i < total; i++)
			{
				var px:int = Math.random() * 5 + 6;
				var py:int = Math.random() * 5 + 6;
				
				world.addFeature(new RotatingTowerTrap_4Way(world, room.position.x * 8 + px, room.position.y * 8 + py));
			}
		}
	}
}