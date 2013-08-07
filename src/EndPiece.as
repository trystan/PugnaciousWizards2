package  
{
	public class EndPiece implements Item
	{
		public function get name():String { return "piece of the amulet"; }
		
		public function get description():String { return "This is one of the pieces you came here for.\nPick it up, find the others, and escape to win."; }
		
		public function canBePickedUpBy(creature:Creature):Boolean { return creature is Hero || creature is Player; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			if (creature is Player || creature is Hero)
			{
				creature.world.removeItemsAt(creature.position.x, creature.position.y);
				creature.endPiecesPickedUp++;
			}
		}
		
		public function update():void
		{
		}
	}
}