package payloads 
{
	public class Ice implements Payload
	{
		public function hit(creature:Player):void
		{
			creature.takeDamage(2);
			creature.freeze(2);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
		}
	}
}