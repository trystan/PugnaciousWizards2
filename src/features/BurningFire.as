package features 
{
	import payloads.Fire;
	public class BurningFire extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var payload:Fire = new Fire();
		
		public function BurningFire(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			
			update();
		}
		
		override public function update():void
		{
			var creature:Creature = world.getCreature(x, y);
			if (creature != null)
			{
				if (creature.fireCounter == 0)
					creature.burn(5);
				else
					creature.burn(2);
			}
			
			if (Math.random() < world.getTile(x, y - 1).burnChance)
				world.addFeature(new BurningFire(world, x, y - 1));
			if (Math.random() < world.getTile(x, y + 1).burnChance)
				world.addFeature(new BurningFire(world, x, y + 1));
			if (Math.random() < world.getTile(x - 1, y).burnChance)
				world.addFeature(new BurningFire(world, x- 1, y));
			if (Math.random() < world.getTile(x + 1, y).burnChance)
				world.addFeature(new BurningFire(world, x + 1, y));
				
			switch (world.getTile(x, y))
			{
				case Tile.door_closed:
					world.addTile(x, y, Tile.door_closed_fire);
					break;
				case Tile.door_opened:
					world.addTile(x, y, Tile.door_opened_fire);
					break;
				case Tile.door_closed_fire:
					if (Math.random() < 0.33)
					{
						world.addTile(x, y, Tile.floor_light);
						world.removeFeature(this);
					}
					break;
				case Tile.door_opened_fire:
					if (Math.random() < 0.33)
					{
						world.addTile(x, y, Tile.floor_light);
						world.removeFeature(this);
					}
					break;
					
				case Tile.tree:
					world.addTile(x, y, Tile.tree_fire_3);
					break;
				case Tile.tree_fire_3:
					if (Math.random() < 0.5)
						world.addTile(x, y, Tile.tree_fire_2);
					break;
				case Tile.tree_fire_2:
					if (Math.random() < 0.5)
						world.addTile(x, y, Tile.tree_fire_1);
					break;
				case Tile.tree_fire_1:
					if (Math.random() < 0.5)
						world.addTile(x, y, Tile.grass_fire);
					break;
					
				case Tile.grass:
					world.addTile(x, y, Tile.grass_fire);
					break;
				case Tile.grass_fire:
					if (Math.random() < 0.5)
					{
						world.addTile(x, y, Tile.burnt_ground);
						world.removeFeature(this);
					}
					break;
					
				default:
					world.removeFeature(this);
			}
		}
	}
}