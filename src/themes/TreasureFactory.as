package themes 
{
	import spells.*;
	
	public class TreasureFactory 
	{
		public static var spellList:Array = null;
		private static var totalSpellsAdded:int = 0;
		
		public static function reset():void
		{
			totalSpellsAdded = 0;
			spellList = [
				new Scroll(new BloodHeal()),
				new Scroll(new BloodBurn()),
				new Scroll(new BlindingBlink()),
				new Scroll(new BoneSplode()),
				new Scroll(new Winter()),
				new Scroll(new Inferno()),
				new Scroll(new TimedFlash()),
				new Scroll(new PullAndFreeze()),
				new Scroll(new TreeAlly()),
				new Scroll(new SummonElemental()),
			];
		}
		
		public static function random():Item
		{
			if (spellList == null)
				reset();
				
			if (spellList.length == 0 || totalSpellsAdded >= 9)
				return new HealthContainer();
				
			var index:int = Math.random() * spellList.length;
			
			totalSpellsAdded++;
			
			return spellList.splice(index, 1)[0];
		}
	}

}