package  
{
	import themes.*;
	
	public class CurrentGameVariables
	{
		public static var rarePercent:Number;
		public static var bloodloss:int;
		public static var defaultVisionRadius:int;
		public static var fogSpread:Number;
		public static var explosionSpread:Number;
		public static var storeCost:int;
		
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
		public static var treeChance:Number;
		public static var goldCount:int;
		public static var extraBoneCount:int;
		public static var extraBloodCount:int;
		
		public static function reset():void
		{
			TreasureFactory.reset();
			RoomThemeFactory.reset();
			
			rarePercent = 0.01;
			subtitle = "Pugnaciouser and Wizarder";
			description = "The default game with default rules.";
			
			explosionSpread = 1.0;
			fogSpread = 1.0;
			defaultVisionRadius = 13;
			pierceDamage = 5;
			fireDamage = 5;
			iceDamage = 1;
			poisonDamage = 1;
			storeCost = 20;
			
			fireChance = 0.02;
			iceChance = 0.02;
			poisonChance = 0.02;
			
			archerCount = 1;
			archerHealth = 15;
			archerDamage = 2;
			
			guardCount = 1;
			guardHealth = 20;
			guardDamage = 10;
			
			skeletonRecoveryTime = 60;
			skeletonHealth = 5;
			skeletonDamage = 5;
			
			bloodloss = 2;
			
			extraConnectionChance = 0.125 + Math.random() / 8;
			stoneDoorChance = 0.125 + Math.random() / 8;
			barChance = 0.10 + Math.random() / 10;
			goldCount = 40 + Math.random() * 10 + Math.random() * 10;
			extraBoneCount = 0;
			extraBloodCount = 0;
			treeChance = 0.125 + Math.random() * 0.25;
			
			for (var i:int = 0; i < 3; i++)
				RoomThemeFactory.themeList.splice((int)(Math.random() * RoomThemeFactory.themeList.length), 1);
			
			var day:String  = [
				"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
			][new Date().getDay()];
			
			var variants:Array = [
				new Variant(day + " sale", "Everything in the store is 20% off.", function ():void {
					CurrentGameVariables.storeCost = CurrentGameVariables.storeCost * 0.8;
				}),
				new Variant("Gore", "Blood ... everywhere.", function ():void {
					CurrentGameVariables.extraBloodCount = 7 * 7 * 9 * 9 * 0.33;
				}),
				new Variant("Explosions", "Explosions spread farther.", function ():void {
					CurrentGameVariables.explosionSpread = 2.5;
				}),
				new Variant("Fog", "Fog spread farther and all vision is reduced.", function ():void {
					CurrentGameVariables.defaultVisionRadius *= 0.75;
					CurrentGameVariables.fogSpread = 1.5;
				}),
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
				new Variant("Henchmen", "Guards and archers are both more common.", function ():void {
					CurrentGameVariables.guardCount *= 3;
					RoomThemeFactory.themeList.push(new GuardRoom());
					RoomThemeFactory.themeList.push(new GuardBarracks());
					
					CurrentGameVariables.archerCount *= 3;
					RoomThemeFactory.themeList.push(new ArcherRoom());
					RoomThemeFactory.themeList.push(new ArcherBarracks());
				}),
				new Variant("Swords", "Everyone does more melee damage - except for you.", function ():void {
					CurrentGameVariables.archerDamage *= 3;
					CurrentGameVariables.guardDamage *= 3;
					CurrentGameVariables.skeletonDamage *= 3;
				}),
				new Variant("Armor", "Everyone has more health - except for you.", function ():void {
					CurrentGameVariables.archerHealth *= 2;
					CurrentGameVariables.guardHealth *= 2;
					CurrentGameVariables.skeletonHealth *= 2;
				}),
				new Variant("Arrows", "Piercing attacks do more damage.", function ():void {
					CurrentGameVariables.pierceDamage *= 2;
				}),
				new Variant("Blood", "Bloodloss is doubled.", function ():void {
					CurrentGameVariables.bloodloss *= 2;
				}),
				new Variant("Bones", "Piles of bones litter the castle.", function ():void {
					CurrentGameVariables.extraBoneCount = 25 + Math.random() * 25 + Math.random() * 25;
				}),
				new Variant("Fire", "Fire does double damage and is more common.", function ():void {
					CurrentGameVariables.fireDamage *= 2;
					CurrentGameVariables.fireChance = 0.25;
				}),
				new Variant("Ice", "Ice does double damage and is more common.", function ():void {
					CurrentGameVariables.iceDamage *= 2;
					CurrentGameVariables.iceChance = 0.25;
				}),
				new Variant("Poison", "Poison does double damage and is more common.", function ():void {
					CurrentGameVariables.poisonDamage *= 2;
					CurrentGameVariables.poisonChance = 0.25;
				}),
				new Variant("Rarities", "Rare rooms are much more common.", function ():void {
					CurrentGameVariables.rarePercent = 0.5;
				})
			];
			
			for each (var thisTheme:RoomTheme in RoomThemeFactory.themeList)
				variants.push(new RoomVariant(thisTheme.name + "s", thisTheme.name + "s are more common.", thisTheme));
			
			var subtitleParts:Array = [];
			var descriptionParts:Array = [];
			
			var count:int = 2;
			
			if (Math.random() < 0.2)
				count++;
			
			if (Math.random() < 0.2)
				count++;
				
			while (subtitleParts.length < count)
			{
				i = (int)(Math.random() * variants.length);
				subtitleParts.push(variants[i].subtitle);
				descriptionParts.push(variants[i].description);
				variants[i].apply();
				variants.splice(i, 1);
			}

			if (subtitleParts.length < 3)
				subtitle = subtitleParts.join(" and ");
			else {
				subtitleParts[subtitleParts.length - 1] = "and " + subtitleParts[subtitleParts.length - 1];
				subtitle = subtitleParts.join(", ");
			}
			subtitle += ".";
				
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

class RoomVariant
{
	public var subtitle:String;
	public var description:String;
	public var roomTheme:themes.RoomTheme;
	
	public function RoomVariant(subtitle:String, description:String, roomTheme:themes.RoomTheme)
	{
		this.subtitle = subtitle;
		this.description = description;
		this.roomTheme = roomTheme;
	}
	
	public function apply():void
	{
		for (var n:int = 0; n < 8; n++)
			themes.RoomThemeFactory.themeList.push(roomTheme);
	}
}