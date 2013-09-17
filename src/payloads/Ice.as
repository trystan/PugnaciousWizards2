package payloads 
{
	public class Ice implements Payload
	{
		public function hitCreature(creature:Creature):void
		{
			creature.freeze(CurrentGameVariables.iceDamage);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
			switch (world.getTile(x, y))
			{
				case Tile.shallow_water:
				case Tile.poison_water:
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
				case Tile.door_closed_fire:
					world.addTile(x, y, Tile.wood_door_closed);
					break;
				case Tile.door_opened_fire:
					world.addTile(x, y, Tile.wood_door_opened);
					break;
			}
		}
		
		public function isSameAs(other:Payload):Boolean
		{
			return other is Ice;
		}
	}
}