package payloads 
{
	public class Healing implements Payload
	{
		public function hitCreature(creature:Creature):void
		{
			creature.heal(5);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
			switch (world.getTile(x, y, true))
			{
				case Tile.poison_water:
					world.addTile(x, y, Tile.shallow_water);
					break;
				case Tile.dirt:
					world.addTile(x, y, Tile.grass);
					break;
			}
		}
		
		public function isSameAs(other:Payload):Boolean
		{
			return other is Healing;
		}
	}
}