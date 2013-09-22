package payloads 
{
	import animations.MagicMissileProjectile;
	public class PayloadFactory 
	{
		public static function random():Payload
		{
			var r:Number = Math.random();
			
			if (r < CurrentGameVariables.fireChance)
				return new Fire();
			else if (r < CurrentGameVariables.fireChance + CurrentGameVariables.iceChance)
				return new Ice();
			else if (r < CurrentGameVariables.fireChance + CurrentGameVariables.iceChance + CurrentGameVariables.poisonChance)
				return new Poison();
			else
				return new Pierce();
		}
	}
}