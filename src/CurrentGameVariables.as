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
		public static var bloodloss:int;
		
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
			
			bloodloss = 2;
			
			extraConnectionChance = 0.125 + Math.random() / 8;
			stoneDoorChance = 0.125 + Math.random() / 8;
			barChance = 0.05 + Math.random() / 10;
			goldCount = 40 + Math.random() * 10 + Math.random() * 10;
			
			for (var n:int = 0; n < 3; n++)
				RoomThemeFactory.themeList.splice((int)(Math.random() * RoomThemeFactory.themeList.length), 1);
			
			var variants:Array = [
				new Variant("Skeletons", "Skeletons are stronger and recover sooner.", function ():void {
					CurrentGameVariables.skeletonDamage *= 2;
					CurrentGameVariables.skeletonHealth *= 2;
					CurrentGameVariables.skeletonRecoveryTime /= 10;
				}),
				new Variant("Guards", "Guards are stronger and more common.", function ():void {
					CurrentGameVariables.guardCount *= 2;
					CurrentGameVariables.guardDamage *= 2;
					CurrentGameVariables.guardHealth *= 2;
					RoomThemeFactory.themeList.push(new GuardRoom());
					RoomThemeFactory.themeList.push(new GuardBarracks());
					RoomThemeFactory.themeList.push(new GuardBarracks());
				}),
				new Variant("Archers", "Archers are stronger and more common.", function ():void {
					CurrentGameVariables.archerCount *= 2;
					CurrentGameVariables.archerDamage *= 2;
					CurrentGameVariables.archerHealth *= 2;
					RoomThemeFactory.themeList.push(new ArcherRoom());
					RoomThemeFactory.themeList.push(new ArcherBarracks());
					RoomThemeFactory.themeList.push(new ArcherBarracks());
				}),
				new Variant("Melee", "Melee does more damage - except for yours.", function ():void {
					CurrentGameVariables.archerDamage *= 2;
					CurrentGameVariables.guardDamage *= 2;
					CurrentGameVariables.skeletonDamage *= 2;
				}),
				new Variant("Arrows", "Piercing attacks do more damage.", function ():void {
					CurrentGameVariables.pierceDamage *= 2;
				}),
				new Variant("Blood", "Bloodloss is doubled.", function ():void {
					CurrentGameVariables.bloodloss *= 2;
				}),
				new Variant("Fire", "Fire does double damage and is more common.", function ():void {
					CurrentGameVariables.fireDamage *= 2;
					CurrentGameVariables.fireChance = 0.1;
				}),
				new Variant("Ice", "Ice does double damage and is more common.", function ():void {
					CurrentGameVariables.iceDamage *= 2;
					CurrentGameVariables.iceChance = 0.1;
				}),
				new Variant("Poison", "Poison does double damage and is more common.", function ():void {
					CurrentGameVariables.poisonDamage *= 2;
					CurrentGameVariables.poisonChance = 0.1;
				}),
				new Variant("Rare rooms", "Rare rooms are much more common.", function ():void {
					CurrentGameVariables.rarePercent = 0.1;
				})
			];
			
			for each (var theme:RoomTheme in RoomThemeFactory.themeList)
			{
				variants.push(new Variant(theme.name + "s", theme.name + "s are more common.", function ():void {
					for (var n:int = 0; n < 6; n++)
						RoomThemeFactory.themeList.push(theme);
				}));
			}
			
			var subtitleParts:Array = [];
			var descriptionParts:Array = [];
			
			var count:int = Math.random() < 0.2 ? 3 : 2;
			while (subtitleParts.length < count)
			{
				var i:int = (int)(Math.random() * variants.length);
				subtitleParts.push(variants[i].subtitle);
				descriptionParts.push(variants[i].description);
				variants[i].apply();
				variants.splice(i, 1);
			}

			subtitle = subtitleParts.join(" and ");
			subtitle = subtitle.charAt(0).toUpperCase() + subtitle.substr(1).toLowerCase();
			description = descriptionParts.join(" ");
		}
	}
}

class Variant
{
	public var subtitle:String;
	public var description:String;
	public var apply:Function;
	
	public function Variant(subtitle:String, description:String, func:Function)
	{
		this.subtitle = subtitle;
		this.description = description;
		this.apply = func;
	}
}