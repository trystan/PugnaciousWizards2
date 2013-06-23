package payloads 
{
	public class Pierce implements Payload
	{
		public function hitCreature(creature:Creature):void
		{
			creature.hurt(2, "You've been killed by a piercing blow.");
			creature.bleed(5);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
		}
	}
}