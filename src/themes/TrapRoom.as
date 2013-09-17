package themes
{
	import features.CastleFeature;
	import features.RotatingTowerTrap;
	import features.RotatingTowerTrap_4Way;
	import features.TowerTrap;
	import flash.geom.Point;
	
	public class TrapRoom implements RoomTheme
	{
		public function get name():String { return "Trap room"; }
		
		public function apply(room:Room, world:World):void
		{
			var points:int = 2 + room.distance / 3 * 2;
			
			if (Math.random() < CurrentGameVariables.rarePercent)
				points *= 2;
			
			var tries:int = 0;
			var table:Array = [
				{ cost:2, func:addGuard },
				{ cost:3, func:addArcher },
				{ cost:2, func:addTower2 },
				{ cost:4, func:addTower4 },
				{ cost:6, func:addWallTraps },
				{ cost:8, func:addTower8 },
			];
			
			while (tries++ < 100 && points > 0)
			{
				var candidate:Object = table[(int)(Math.random() * table.length)];
				
				if (candidate.cost <= points)
				{
					points -= candidate.cost;
					candidate.func(room, world);
				}
			}
		}
		
		private function addWall(room:Room, world:World):void 
		{
			var px:int = Math.random() * 5 + 6;
			var py:int = Math.random() * 5 + 6;

			while (world.getTile(px, py).blocksMovement)
			{
				px = Math.random() * 5 + 6;
				py = Math.random() * 5 + 6;
			}
			world.addTile(px, py, Tile.wall);
		}
		
		private function addGuard(room:Room, world:World):void 
		{
			var px:int = room.worldPosition.x + Math.random() * 7;
			var py:int = room.worldPosition.y + Math.random() * 7;

			while (world.getTile(px, py).blocksMovement)
			{
				px = room.worldPosition.x + Math.random() * 7;
				py = room.worldPosition.y + Math.random() * 7;
			}
			world.addCreature(new Guard(new Point(px, py)));
		}
		
		private function addArcher(room:Room, world:World):void 
		{
			var px:int = room.worldPosition.x + Math.random() * 7;
			var py:int = room.worldPosition.y + Math.random() * 7;

			while (world.getTile(px, py).blocksMovement)
			{
				px = room.worldPosition.x + Math.random() * 7;
				py = room.worldPosition.y + Math.random() * 7;
			}
			world.addCreature(new Archer(new Point(px, py)));
		}
		
		private function addTower2(room:Room, world:World):void 
		{
			var px:int = room.worldPosition.x + Math.random() * 7;
			var py:int = room.worldPosition.y + Math.random() * 7;

			while (world.getTile(px, py).blocksMovement)
			{
				px = room.worldPosition.x + Math.random() * 7;
				py = room.worldPosition.y + Math.random() * 7;
			}
			var f:CastleFeature = new RotatingTowerTrap(world, px, py);
			room.roomFeatures.push(f);
			world.addFeature(f);
		}
		
		private function addTower4(room:Room, world:World):void 
		{
			var px:int = room.worldPosition.x + Math.random() * 7;
			var py:int = room.worldPosition.y + Math.random() * 7;

			while (world.getTile(px, py).blocksMovement)
			{
				px = room.worldPosition.x + Math.random() * 7;
				py = room.worldPosition.y + Math.random() * 7;
			}
			var f:CastleFeature = new RotatingTowerTrap_4Way(world, px, py);
			room.roomFeatures.push(f);
			world.addFeature(f);
		}
		
		private function addTower8(room:Room, world:World):void 
		{
			var px:int = room.worldPosition.x + Math.random() * 7;
			var py:int = room.worldPosition.y + Math.random() * 7;

			while (world.getTile(px, py).blocksMovement)
			{
				px = room.worldPosition.x + Math.random() * 7;
				py = room.worldPosition.y + Math.random() * 7;
			}
			var f:CastleFeature = new TowerTrap(world, px, py);
			room.roomFeatures.push(f);
			world.addFeature(f);
		}
		
		private function addWallTraps(room:Room, world:World):void 
		{
			new TrapWalls().apply(room, world);
		}
	}
}