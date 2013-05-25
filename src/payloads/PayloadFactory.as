package payloads 
{
	public class PayloadFactory 
	{
		public static function random():Payload
		{
			var r:Number = Math.random();
			
			if (r < 0.125)
				return new Fire();
			else if (r < 0.25)
				return new Magic();
			else
				return new Pierce();
		}
	}
}