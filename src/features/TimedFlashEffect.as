package features 
{
	public class TimedFlashEffect extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var timer:int = 6;
		
		public function TimedFlashEffect(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			
			update();
		}
		
		override public function update():void
		{
			if (timer-- < 1)
			{
				for each (var creature:Creature in world.creatures)
				{
					if (!creature.canSee(x, y))
						continue;
					
					creature.takeDamage(1, "Fried by a timed flash spell.");
					creature.blind(Math.random() * 25 + Math.random() * 25 + 25);
				}
				world.removeFeature(this);
			}
		}
	}
}