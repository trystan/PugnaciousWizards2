package themes 
{
	public class RoomThemeFactory 
	{
		private static var themeList:Array = [
			new EmptyRoom(),
			new Courtyard(),
			new TrapFloors(),
			new TrapWalls(),
			new TrapTower(),
			new RotatingTrapTower(),
		];
		
		public static function random():RoomTheme
		{
			return themeList[Math.floor(Math.random() * themeList.length)];
		}
	}
}