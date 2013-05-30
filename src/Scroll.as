package  
{
	import spells.Spell;
	
	public class Scroll implements Item
	{
		public var spell:Spell;
		
		public function Scroll(spell:Spell) 
		{
			this.spell = spell;
		}
	}
}