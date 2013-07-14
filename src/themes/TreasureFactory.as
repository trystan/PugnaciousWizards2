package themes 
{
	import spells.*;
	
	public class TreasureFactory 
	{
		public static var spellList:Array = null;
		
		public static function reset():void
		{
			spellList = [];
			
			var list:Array = [
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
				new Scroll(new BloodJellies()),
			];
			
			while (spellList.length < 9)
			{
				var index:int = Math.random() * list.length;
				spellList.push(list.splice(index, 1)[0]);
			}
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