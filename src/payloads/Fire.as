package payloads 
{
	public class Fire implements Payload
	{
		public function hit(creature:Player):void
		{
			creature.takeDamage(5);
		}
	}
}