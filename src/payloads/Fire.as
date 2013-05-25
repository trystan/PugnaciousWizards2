package payloads 
{
	public class Fire implements Payload
	{
		public function hit(creature:Player):void
		{
			creature.takeDamage(2);
			creature.catchOnFire(6);
		}
	}
}