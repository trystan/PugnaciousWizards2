package  
{
	import flash.geom.Point;
	import spells.HealingFog;
	import spells.PoisonFog;
	import spells.Telekenesis;
	
	public class Player extends Creature
	{
		public function Player(position:Point) 
		{
			super(position, "Player",
				"This is you!\n\n" +
				"You are on a quest to enter the castle, find the three " +
				"pieces of the amulet, and escape alive. There are many " +
				"traps and defenders though so you must rely on your " +
				"wits - and any items you find - to survive.");
				
			isGoodGuy = true;
			usesMagic = true;
		}
	}
}