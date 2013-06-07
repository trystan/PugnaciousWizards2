package spells 
{
	public class SpellCastAction 
	{
		public var percentChance:Number;
		public var callback:Function;
		
		public function SpellCastAction(percentChance:Number, callback:Function) 
		{
			this.percentChance = percentChance;
			this.callback = callback;
		}
	}
}