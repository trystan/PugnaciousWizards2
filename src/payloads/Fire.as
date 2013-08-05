package payloads 
{
	import features.BurningFire;
	
	public class Fire implements Payload
	{
		public function hitCreature(creature:Creature):void
		{
			creature.hurt(5, "You burned to death.");
			creature.burn(5);
			hitTile(creature.world, creature.position.x, creature.position.y);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
			if (world.getTile(x, y, true).burnChance > 0)
				world.addFeature(new BurningFire(world, x, y));
		}
	}
}