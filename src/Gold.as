package  
{
	public class Gold implements Item
	{
		public function get name():String { return "gold"; }
		
		public function get description():String { return "It's gold. Press the \"$\" key to buy spells with it."; }
		
		public function canBePickedUpBy(creature:Creature):Boolean { return true; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			creature.world.removeItemAt(creature.position.x, creature.position.y);
			creature.gold += 1;
		}
		
		public function update():void
		{
		}
	}
}