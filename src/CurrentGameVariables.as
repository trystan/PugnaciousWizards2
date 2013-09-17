package  
{
	import themes.ArcherBarracks;
	import themes.ArcherRoom;
	import themes.GuardBarracks;
	import themes.GuardRoom;
	import themes.MysticRoom;
	import themes.RoomTheme;
	import themes.RoomThemeFactory;
	import themes.RotatingTrapTower;
	import themes.RotatingTrapTower_4Way;
	import themes.TrapWalls;
	import themes.TreasureFactory;
	
	public class CurrentGameVariables
	{
		public static var rarePercent:Number;
		
		public static var archerCount:int;
		public static var archerHealth:int;
		public static var archerDamage:int;
		
		public static var guardCount:int;
		public static var guardHealth:int;
		public static var guardDamage:int;
		
		public static var pierceDamage:int;
		public static var fireDamage:int;
		public static var iceDamage:int;
		public static var poisonDamage:int;
		
		public static var fireChance:Number;
		public static var iceChance:Number;
		public static var poisonChance:Number;
		
		public static var skeletonHealth:int;
		public static var skeletonDamage:int;
		public static var skeletonRecoveryTime:int;
		
		public static var subtitle:String;
		public static var description:String;
		
		public static var extraConnectionChance:Number;
		public static var stoneDoorChance:Number;
		public static var barChance:Number;
		public static var goldCount:int;
		
		public static function reset():void
		{
			TreasureFactory.reset();
			RoomThemeFactory.reset();
			
			rarePercent = 0.01;
			subtitle = "Pugnaciouser and Wizarder";
			description = "The default game with default rules.";
			
			archerCount = 1;
			archerHealth = 15;
			archerDamage = 2;
			
			guardCount = 1;
			guardHealth = 20;
			guardDamage = 10;
			
			pierceDamage = 5;
			fireDamage = 10;
			iceDamage = 1;
			poisonDamage = 1;
			
			fireChance = 0.02;
			iceChance = 0.02;
			poisonChance = 0.02;
			
			skeletonHealth = 5;
			skeletonDamage = 5;
			skeletonRecoveryTime = 60;
			
			extraConnectionChance = 0.25;
			stoneDoorChance = 0.25;
			barChance = 1.0 / 9.0;
			goldCount = 50;
			
			var i:int;
			
			i = (int)(Math.random() * RoomThemeFactory.themeList.length);
			RoomThemeFactory.themeList.splice(i, 1);
			
			i = (int)(Math.random() * RoomThemeFactory.themeList.length)
			RoomThemeFactory.themeList.splice(i, 1);
			
			i = (int)(Math.random() * RoomThemeFactory.themeList.length)
			RoomThemeFactory.themeList.push(RoomThemeFactory.themeList[i]);
			
			switch ((int)(Math.random() * 10))
			{
				case 0:
					subtitle = "Skeleton's revenge";
					description = "Skeletons do more damage, take more damage, and recover sooner.";
					skeletonHealth *= 2;
					skeletonDamage *= 2;
					skeletonRecoveryTime /= 2;
					break;
				case 2:
					subtitle = "An uncommon castle";
					description = "Rare rooms are 10 times as likely.";
					rarePercent *= 10;
					break;
				case 3:
					subtitle = "Pins and needles";
					description = "Archers, arrow towers, and arrow walls are more common. Piercing attacks do more damage.";
					archerCount *= 2;
					pierceDamage *= 2;
					RoomThemeFactory.themeList.push(new ArcherRoom());
					RoomThemeFactory.themeList.push(new ArcherBarracks());
					RoomThemeFactory.themeList.push(new RotatingTrapTower());
					RoomThemeFactory.themeList.push(new RotatingTrapTower_4Way());
					RoomThemeFactory.themeList.push(new TrapWalls());
					break;
				case 4:
					subtitle = "Swords and shields";
					description = "Guards are much stronger, do more damage, and are more common.";
					guardCount *= 2;
					guardHealth *= 2;
					guardDamage *= 2;
					RoomThemeFactory.themeList.push(new GuardRoom());
					RoomThemeFactory.themeList.push(new GuardBarracks());
					break;
				case 5:
					subtitle = "Death by fire";
					description = "Fire does twice as much damage. Fire traps are much more common.";
					fireDamage *= 2;
					fireChance = 0.1;
					stoneDoorChance = 0.5;
					break;
				case 6:
					subtitle = "Death by ice";
					description = "Ice does twice as much damage. Ice traps are much more common.";
					iceDamage *= 2;
					iceChance = 0.1;
					break;
				case 7:
					subtitle = "Death by poison";
					description = "Poison does twice as much damage. Poison traps are much more common.";
					poisonDamage *= 2;
					poisonChance = 0.1;
					break;
				case 8:
					i = (int)(Math.random() * RoomThemeFactory.themeList.length);
					var preferredRoomTheme:RoomTheme = RoomThemeFactory.themeList[i];
					
					subtitle = preferredRoomTheme.name;
					description = "Hope you like " + preferredRoomTheme.name + "s.";
					
					for (var n:int = 0; n < 8; n++)
						RoomThemeFactory.themeList.push(preferredRoomTheme);
					break;
				case 9:
					subtitle = "The mystic jail";
					description = "This castle is a jail for magic users.";
					barChance *= 5;
					guardCount *= 2;
					archerCount *= 2;
					stoneDoorChance = 0.9;
					RoomThemeFactory.themeList.push(new MysticRoom());
					RoomThemeFactory.themeList.push(new MysticRoom());
					RoomThemeFactory.themeList.push(new MysticRoom());
					RoomThemeFactory.themeList.push(new MysticRoom());
					goldCount = Math.random() * 25 + Math.random() * 25;
					break;
			}
		}
	}
}