package payloads 
{
	public class Magic implements Payload
	{
		public function hit(creature:Player):void
		{
			creature.takeDamage(5);
		}
	}
}