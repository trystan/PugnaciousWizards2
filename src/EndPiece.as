package  
{
	public class EndPiece implements Item
	{
		public function get name():String { return "piece of the amulet"; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			if (creature is Player || creature is Hero)
			{
				creature.world.removeItem(creature.position.x, creature.position.y);
				creature.endPiecesPickedUp++;
			}
		}
	}
}