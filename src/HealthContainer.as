package  
{
	public class HealthContainer implements Item
	{
		public function get name():String { return "health container"; }
		
		public function get description():String { return "This health container will give you 5 health, possibly increasing your maximum health in the process."; }
		
		public function canBePickedUpBy(creature:Creature):Boolean { return true; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			creature.heal(5, true);
		}
		
		public function update():void
		{
		}
	}
}