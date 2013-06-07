package payloads 
{
	import features.BurningFire;
	public class Fire implements Payload
	{
		public function hit(creature:Player):void
		{
			creature.takeDamage(2, "Burned to death.");
			creature.burn(6);
			hitTile(creature.world, creature.position.x, creature.position.y);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
			if (world.getTile(x, y).burnChance > 0)
				world.addFeature(new BurningFire(world, x, y));
		}
	}
}