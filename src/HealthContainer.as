package  
{
	public class HealthContainer implements Item
	{
		public function get name():String { return "health container"; }
		
		public function get description():String { return "This heart will give you 5 health, possibly increasing your maximum health in the process."; }
		
		public function canBePickedUpBy(creature:Creature):Boolean { return true; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			creature.world.removeItemsAt(creature.position.x, creature.position.y);
			creature.heal(5, true);
		}
		
		public function update():void
		{
		}
	}
}