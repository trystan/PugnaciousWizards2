package themes 
{
	public class RoomThemeFactory 
	{
		private static var allThemes:Array = [
			new EmptyRoom(),
			new Courtyard(),
			new TrapFloors(),
			new TrapWalls(),
			new TrapTower(),
			new RotatingTrapTower(),
			new RotatingTrapTower_4Way(),
			new MovingBlocks(),
			new GuardRoom(),
			new ArcherRoom(),
			new MysticRoom(),
			new GuardBarracks(),
			new ArcherBarracks(),
			new PortalRoom(),
			new PoolRoom(),
			new TrapRoom(),
		];
		
		public static var themeList:Array = null;
		
		public static function reset():void
		{
			themeList = allThemes.slice();
			
			// some rooms are more common
			themeList.push(new PortalRoom());
			themeList.push(new TrapRoom());
			themeList.push(new TrapRoom());
		}
		
		public static function random():RoomTheme
		{
			if (themeList == null)
				reset();
				
			return themeList[Math.floor(Math.random() * themeList.length)];
		}
	}
}