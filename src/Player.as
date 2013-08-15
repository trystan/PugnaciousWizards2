package  
{
	import flash.geom.Point;
	import spells.AlterReality;
	import spells.DarkJump;
	import spells.HealingFog;
	import spells.PoisonFog;
	import spells.Spell;
	import spells.TimedMeteor;
	
	public class Player extends Creature
	{
		public function Player(position:Point) 
		{
			super(position, "Player",
				"This is you!\n\n" +
				"For whatever reason, you've decided to enter this castle, " +
				"take the three amulets, and escape back outside. " +
				"There are many traps and defenders so you must rely on your " +
				"wits - and any items you find - to survive.\n\n" +
				"You'll probably just die though....\n\n");
				
			isGoodGuy = true;
			usesMagic = true;
		}
		
		override public function addMagicSpell(spell:Spell):void 
		{
			super.addMagicSpell(spell);
			
			Globals.learnSpell(spell);
		}
		
		override public function die():void 
		{
			super.die();
			
			Globals.numberOfTimesDied++;
		}
	}
}