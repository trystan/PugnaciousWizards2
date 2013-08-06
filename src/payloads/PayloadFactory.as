package payloads 
{
	import animations.MagicMissileProjectile;
	public class PayloadFactory 
	{
		public static function random():Payload
		{
			var r:Number = Math.random();
			var chance:Number = 0.1;
			
			if (r < chance * 1)
				return new Fire();
			else if (r < chance * 2)
				return new Ice();
			else if (r < chance * 3)
				return new Poison();
			else
				return new Pierce();
		}
	}
}