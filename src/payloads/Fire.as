package payloads 
{
	import features.BurningFire;
	public class Fire implements Payload
	{
		public function hit(creature:Player):void
		{
			creature.takeDamage(2);
			creature.burn(6);
			hitTile(creature.world, creature.position.x, creature.position.y);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
			world.addFeature(new BurningFire(world, x, y));
		}
	}
}