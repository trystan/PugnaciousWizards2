package  
{
	import spells.Spell;
	
	public class PileOfBones implements Item
	{
		public function get name():String { return "pile of bones"; }
		
		public function get description():String { return "A pile of bones."; }
		
		public function PileOfBones() 
		{
		}
		
		public function canBePickedUp():Boolean { return false; }
		
		public function getPickedUpBy(creature:Creature):void
		{
		}
	}
}