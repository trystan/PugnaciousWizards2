package  
{
	import flash.geom.Point;
	
	public class Guard extends Creature
	{
		public function Guard(position:Point)
		{
			super(position);
			
			maxHealth = 5 * 3;
			health = maxHealth;
		}
		
		public override function doAi():void
		{
			if (canSeeCreature(world.player))
			{
				var mx:int = position.x < world.player.position.x ? 1 : (position.x > world.player.position.x ? -1 : 0);
				var my:int = position.y < world.player.position.y ? 1 : (position.y > world.player.position.y ? -1 : 0);
				moveBy(mx, my);
			}
			else
			{
				wanderRandomly();
			}
		}
	}
}