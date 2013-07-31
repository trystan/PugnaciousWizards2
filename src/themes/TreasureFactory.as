package themes 
{
	import flash.geom.Point;
	import spells.*;
	
	public class TreasureFactory 
	{
		public static var spellList:Array = null;
		public static var nextWizardNumber:int = 0;
		
		public static function reset():void
		{
			nextWizardNumber = 0;
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
				new Scroll(new PoisonFog()),
				new Scroll(new Telekenesis()),
				new Scroll(new HealingFog()),
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
		
		static public function randomWizard(room:Room):EnemyWizard 
		{
			var w:EnemyWizard = new EnemyWizard(new Point(room.worldPosition.x + 3, room.worldPosition.y + 3));
			
			switch (nextWizardNumber++)
			{
				case 0:
					w.addMagicSpell(new FireJump());
					w.addMagicSpell(new BloodBurn());
					w.addMagicSpell(new BoneSplode());
					w.addMagicSpell(new Inferno());
					w.aura = "fire";
					break;
				case 1:
					w.addMagicSpell(new PullAndFreeze());
					w.addMagicSpell(new Winter());
					w.addMagicSpell(new HealingFog());
					w.addMagicSpell(new PoisonFog());
					w.aura = "cold & fog";
					break;
				case 2:
					w.addMagicSpell(new BloodHeal());
					w.addMagicSpell(new MagicMissile());
					w.addMagicSpell(new Telekenesis());
					w.addMagicSpell(new BlindingBlink());
					w.addMagicSpell(new TimedFlash());
					w.aura = "magic";
					break;
			}
			
			return w;
		}
	}
}