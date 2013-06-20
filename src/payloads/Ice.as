package payloads 
{
	public class Ice implements Payload
	{
		public function hit(creature:Creature):void
		{
			if (creature.freezeCounter < 1)
				creature.takeDamage(2, "Frooze to death.");
			creature.freeze(2);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
		}
	}
}