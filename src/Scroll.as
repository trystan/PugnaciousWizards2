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
		
		public function canBePickedUp():Boolean { return true; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			if (creature is Player || creature is Hero)
			{
				creature.world.removeItem(creature.position.x, creature.position.y);
				creature.addMagicSpell(spell);
			}
		}
	}
}