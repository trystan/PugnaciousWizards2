package themes 
{
	import spells.*;
	
	public class TreasureFactory 
	{
		public static var spellList:Array = null;
		
		public static function reset():void
		{
			spellList = [
				new Scroll(new BloodHeal()),
				new Scroll(new BloodBurn()),
				new Scroll(new BlindingBlink()),
				new Scroll(new BoneSplode()),
				new Scroll(new Winter()),
				new Scroll(new TimedFlash()),
				new Scroll(new PullAndFreeze()),
			];
		}
		
		public static function random():Item
		{
			if (spellList == null)
				reset();
				
			if (spellList.length == 0)
				return new HealthContainer();
				
			var index:int = Math.random() * spellList.length;
			
			return spellList.splice(index, 1)[0];
		}
	}

}