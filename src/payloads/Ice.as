package payloads 
{
	public class Ice implements Payload
	{
		public function hitCreature(creature:Creature):void
		{
			creature.freeze(2);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
			if (world.getTile(x, y) == Tile.shallow_water)
				world.addTile(x, y, Tile.frozen_water);
		}
	}
}