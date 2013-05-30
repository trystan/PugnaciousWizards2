package payloads 
{
	public class Pierce implements Payload
	{
		public function hit(creature:Player):void
		{
			creature.takeDamage(3);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
		}
	}
}