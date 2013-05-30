package  
{
	import spells.FireJump;
	
	public class Scroll implements Item
	{
		public var spell:FireJump;
		
		public function Scroll(spell:FireJump) 
		{
			this.spell = spell;
		}
	}
}