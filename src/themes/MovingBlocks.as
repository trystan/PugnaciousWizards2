package themes 
{
	import features.MovingWall;
	public class MovingBlocks implements RoomTheme
	{
		public function apply(room:Room, world:World):void 
		{
			if (Math.random() < 0.5)
				westEast(room, world);
			else
				northSouth(room, world);
		}	
		
		private function northSouth(room:Room, world:World):void 
		{
			for (var x:int = 0; x < 7; x++)
			for (var y:int = 0; y < 7; y++)
				world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, ((x + y) % 2) == 0 ? Tile.track_light_ns : Tile.track_dark_ns);
			
			for (x = 0; x < 7; x++)
			{
				y = Math.random() * 8;
				world.addFeature(new MovingWall(world, room.worldPosition.x + x, room.worldPosition.y + y, 0, 1));
			}
		}
		
		private function westEast(room:Room, world:World):void 
		{
			for (var x:int = 0; x < 7; x++)
			for (var y:int = 0; y < 7; y++)
				world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, ((x + y) % 2) == 0 ? Tile.track_light_we : Tile.track_dark_we);
			
			for (y = 0; y < 7; y++)
			{
				x = Math.random() * 8;
				world.addFeature(new MovingWall(world, room.worldPosition.x + x, room.worldPosition.y + y, 1, 0));
			}
		}
	}
}