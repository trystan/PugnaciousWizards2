package  
{
	import flash.geom.Point;
	import knave.AStar;
	import spells.AlterReality;
	import spells.DarkJump;
	import spells.HealingFog;
	import spells.PoisonFog;
	import spells.Spell;
	import spells.TimedMeteor;
	
	public class Player extends Creature
	{
		public var path:Array = [];
		
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
		
		public function pathTo(x:int, y:int):void
		{
			path = AStar.pathTo(
					function(x0:int, y0:int):Boolean { return !world.getTile(x0, y0, true).blocksMovement || world.isClosedDoor(x0, y0); },
					position,
					new Point(x, y), 
					false);
		}
		
		public function stepOnce():void 
		{
			var next:Point = path.shift();
			
			moveBy(clamp(next.x - position.x), clamp(next.y - position.y));
			
			if (path.length == 1 && world.isOpenedDoor(path[0].x, path[0].y))
				path.shift();
		}
		
		private function clamp(n:int):int
		{
			return Math.max( -1, Math.min(n, 1));
		}
	}
}