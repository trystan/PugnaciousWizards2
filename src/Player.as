package  
{
	import flash.geom.Point;
	import spells.PullAndFreeze;
	
	public class Player extends Creature
	{
		public function Player(position:Point) 
		{
			super(position, "Player",
				"This is you!\n\n" +
				"You are on a quest to enter the castle, find the three\n" +
				"pieces of the amulet, and escape alive. There are many\n" +
				"traps and defenders though so you must rely on your\n" +
				"wits - and any items you find - to survive.");
				
			isGoodGuy = true;
		}
	}
}