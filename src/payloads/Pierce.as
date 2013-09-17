package payloads 
{
	public class Pierce implements Payload
	{
		public function hitCreature(creature:Creature):void
		{
			creature.hurt(CurrentGameVariables.pierceDamage, "You've been killed by a piercing blow.");
			creature.bleed(2);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
		}
		
		public function isSameAs(other:Payload):Boolean
		{
			return other is Pierce;
		}
	}
}