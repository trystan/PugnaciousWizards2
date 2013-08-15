package  
{
	import flash.geom.Point;
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
				"You are on a quest to enter the castle, find the three " +
				"pieces of the amulet, and escape alive. There are many " +
				"traps and defenders though so you must rely on your " +
				"wits - and any items you find - to survive.\n\n" +
				"You probably won't though....\n\n");
				
			isGoodGuy = true;
			usesMagic = true;
		}
		
		override public function addMagicSpell(spell:Spell):void 
		{
			super.addMagicSpell(spell);
			
			Globals.learnSpell(spell);
		}
	}
}