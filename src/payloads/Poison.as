package payloads 
{
	public class Poison implements Payload
	{
		public function hitCreature(creature:Creature):void
		{
			creature.poison(CurrentGameVariables.poisonDamage);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
			switch (world.getTile(x, y, true))
			{
				case Tile.shallow_water:
					world.addTile(x, y, Tile.poison_water);
					break;
				case Tile.grass:
				case Tile.grass_fire:
				case Tile.tree:
				case Tile.tree_fire_1:
				case Tile.tree_fire_2:
				case Tile.tree_fire_3:
					world.addTile(x, y, Tile.dirt);
					break;
			}
		}
		
		public function isSameAs(other:Payload):Boolean
		{
			return other is Poison;
		}
	}
}