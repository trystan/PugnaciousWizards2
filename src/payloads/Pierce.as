package payloads 
{
	public class Pierce implements Payload
	{
		public function hit(creature:Player):void
		{
			creature.takeDamage(3, "Killed by a piercing blow.");
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
		}
	}
}