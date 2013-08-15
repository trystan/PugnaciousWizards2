package themes 
{
	import flash.geom.Point;
	import payloads.Fire;
	import payloads.Ice;
	import payloads.Poison;
	import spells.*;
	
	public class TreasureFactory 
	{
		public static var spellList:Array = null;
		public static var nextWizardNumber:int = 0;
		
		public static var allSpells:Array = [
			new FireJump(),
			new HealAndWeaken(),
			new MagicMissile(),
			
			new BloodHeal(),
			new BloodBurn(),
			new BlindingBlink(),
			new BoneSplode(),
			new Winter(),
			new Inferno(),
			new TimedFlash(),
			new PullAndFreeze(),
			new AngryTreeSpell(),
			new SummonGolem(),
			new BloodJellies(),
			new PoisonFog(),
			new Telekenesis(),
			new HealingFog(),
			new TimedMeteor(),
			new MidasBones(),
		];
		
		public static function reset():void
		{
			nextWizardNumber = 0;
			spellList = [];
			
			var list:Array = allSpells.slice(3); // skip the three spells outside the castle
			
			while (spellList.length < 9)
			{
				var index:int = Math.random() * list.length;
				spellList.push(new Scroll(list.splice(index, 1)[0]));
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
					w.aura = new Fire();
					w.type = "Wizard of fire";
					break;
				case 1:
					w.addMagicSpell(new PullAndFreeze());
					w.addMagicSpell(new Winter());
					w.addMagicSpell(new HealingFog());
					w.aura = new Ice();
					w.type = "Wizard of ice";
					break;
				case 2:
					w.addMagicSpell(new PoisonFog());
					w.addMagicSpell(new Telekenesis());
					w.addMagicSpell(new SummonGolem());
					w.addMagicSpell(new BloodJellies());
					w.aura = new Poison();
					w.gold += 20; // for golem upgrades
					w.type = "Wizard of poison & summons";
					break;
			}
			
			return w;
		}
	}
}