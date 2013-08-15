package  
{
	public class EndPiece implements Item
	{
		public function get name():String { return "amulet"; }
		
		public function get description():String { return "This is one of the amulets you came here for.\nPick it up, find the others, and run back outside to win."; }
		
		public function canBePickedUpBy(creature:Creature):Boolean { return creature is Hero || creature is Player; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			if (creature is Player || creature is Hero)
			{
				creature.world.removeItemsAt(creature.position.x, creature.position.y);
				creature.numberOfAmuletsPickedUp++;
			}
		}
		
		public function update():void
		{
		}
	}
}