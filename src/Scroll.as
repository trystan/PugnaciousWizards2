package  
{
	import spells.Spell;
	
	public class Scroll implements Item
	{
		public var spell:Spell;
		
		public function get name():String { return "scroll of " + spell.name; }
		
		public function get description():String { return spell.description; }
		
		public function Scroll(spell:Spell) 
		{
			this.spell = spell;
		}
		
		public function canBePickedUpBy(creature:Creature):Boolean { return creature.usesMagic && creature.magic.length < 9; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			if (creature is Player || creature is Hero)
				creature.addMagicSpell(spell);
		}
		
		public function update():void
		{
		}
	}
}