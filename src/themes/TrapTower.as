package themes
{
	import features.CastleFeature;
	import features.TowerTrap;
	
	public class TrapTower implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			var total:int = (int)(room.distance / 7 + 1);
			
			if (Math.random() < Globals.rarePercent)
				total *= 2;
				
			for (var i:int = 0; i < total; i++)
			{
				var px:int = Math.random() * 5 + 6;
				var py:int = Math.random() * 5 + 6;
				
				var f:CastleFeature = new TowerTrap(world, room.position.x * 8 + px, room.position.y * 8 + py);
				room.roomFeatures.push(f);
				world.addFeature(f);
			}
		}
	}
}