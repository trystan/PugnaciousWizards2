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
			switch (world.getTile(x, y))
			{
				case Tile.shallow_water:
					world.addTile(x, y, Tile.frozen_water);
					break;
				case Tile.tree_fire_1:
				case Tile.tree_fire_2:
				case Tile.tree_fire_3:
					world.addTile(x, y, Tile.tree);
					break;
				case Tile.grass_fire:
					world.addTile(x, y, Tile.grass);
					break;
					
			}
		}
	}
}