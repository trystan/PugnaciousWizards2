package  
{
	public class HealthContainer implements Item
	{
		public function get name():String { return "health container"; }
		
		public function get description():String { return "This heart will give you 5 health, possibly increasing your maximum health in the process."; }
		
		public function canBePickedUp():Boolean { return true; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			creature.world.removeItemAt(creature.position.x, creature.position.y);
			creature.health += 5;
			creature.maxHealth = Math.max(creature.health, creature.maxHealth);
		}
		
		public function update():void
		{
		}
	}
}