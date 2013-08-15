package  
{
	import spells.Spell;
	public class Globals 
	{
		public static var rarePercent:Number = 0.01;
		
		
		
		
		private static var knownSpellNames:Array = [];
		
		public static function learnSpell(spell:Spell):void
		{
			knownSpellNames.push(spell.name);
		}
		
		public static function hasDiscoveredSpell(spell:Spell):Boolean
		{
			return knownSpellNames.indexOf(spell.name) > -1;
		}
	}
}