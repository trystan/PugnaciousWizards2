package features 
{
	public class TimedFlashEffect extends BaseTimedEffect
	{
		public function TimedFlashEffect(world:World, x:int, y:int) 
		{
			super(world, x, y);
		}
		
		override public function timeout():void
		{			
			for each (var creature:Creature in world.creatures)
			{
				if (!creature.canSee(x, y))
					continue;
				
				creature.hurt(1, "Somehow fried by a timed flash spell.");
				creature.blind(Math.random() * 20 + Math.random() * 20 + 10);
			}
		}
	}
}