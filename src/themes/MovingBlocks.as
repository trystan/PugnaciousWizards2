package themes 
{
	import features.MovingWall;
	import flash.geom.Point;
	public class MovingBlocks implements RoomTheme
	{
		public function apply(room:Room, world:World):void 
		{
			switch ((int)(Math.random() * 5))
			{
				case 0: circles(room, world); break;
				case 1: rows(room, world); break;
				case 2: columns(room, world); break;
				case 3: northSouth(room, world); break;
				case 4: westEast(room, world); break;
			}
			
			for (var i:int = 0; i < 7; i++)
			{
				var x:int = Math.random() * 7;
				var y:int = Math.random() * 7;
				world.addBlood(room.worldPosition.x + x, room.worldPosition.y + y);
			}
		}
		
		private function layTrack(room:Room, world:World, tiles:Array):void
		{
			for (var x:int = 0; x < 7; x++)
			for (var y:int = 0; y < 7; y++)
			{
				var light:Boolean = (x + y) % 2 == 0;
				var tile:String = tiles[y].charAt(x);
				
				switch (tile)
				{
					case "|": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_ns : Tile.track_dark_ns); break;
					case "-": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_we : Tile.track_dark_we); break;
					case "3": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_nw : Tile.track_dark_nw); break;
					case "1": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_ne : Tile.track_dark_ne); break;
					case "9": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_sw : Tile.track_dark_sw); break;
					case "7": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_se : Tile.track_dark_se); break;
				}
			}
		}
		
		private function circles(room:Room, world:World):void 
		{
			layTrack(room, world, [
				"7-----9",
				"|7---9|",
				"||7-9||",
				"||| |||",
				"||1-3||",
				"|1---3|",
				"1-----3",
			]);
			
			for each (var offset:int in [0,1,2,4,5,6])
			{
				world.addFeature(new MovingWall(world, room.worldPosition.x + offset, room.worldPosition.y + offset));
			}
		}
		
		private function northSouth(room:Room, world:World):void 
		{
			layTrack(room, world, [
				"|||||||",
				"|||||||",
				"|||||||",
				"|||||||",
				"|||||||",
				"|||||||",
				"|||||||",
			]);
			
			for (var x:int = 0; x < 7; x++)
			{
				var y:int = Math.random() * 7;
				world.addFeature(new MovingWall(world, room.worldPosition.x + x, room.worldPosition.y + y));
			}
		}
		
		private function westEast(room:Room, world:World):void 
		{
			layTrack(room, world, [
				"-------",
				"-------",
				"-------",
				"-------",
				"-------",
				"-------",
				"-------",
			]);
			
			for (var y:int = 0; y < 7; y++)
			{
				var x:int = Math.random() * 7;
				world.addFeature(new MovingWall(world, room.worldPosition.x + x, room.worldPosition.y + y));
			}
		}
		
		private function columns(room:Room, world:World):void 
		{
			layTrack(room, world, [
				"797-979",
				"||| |||",
				"||| |||",
				"||| |||",
				"||| |||",
				"||| |||",
				"131-313",
			]);
			
			world.addFeature(new MovingWall(world, room.worldPosition.x + 0, room.worldPosition.y + Math.random() * 7));
			world.addFeature(new MovingWall(world, room.worldPosition.x + 2, room.worldPosition.y + Math.random() * 7));
			world.addFeature(new MovingWall(world, room.worldPosition.x + 5, room.worldPosition.y + Math.random() * 7));
		}
		
		private function rows(room:Room, world:World):void 
		{
			layTrack(room, world, [
				"7-----9",
				"1-----3",
				"7-----9",
				"|     |",
				"1-----3",
				"7-----9",
				"1-----3",
			]);
			
			world.addFeature(new MovingWall(world, room.worldPosition.x + Math.random() * 7, room.worldPosition.y + 0));
			world.addFeature(new MovingWall(world, room.worldPosition.x + Math.random() * 7, room.worldPosition.y + 2));
			world.addFeature(new MovingWall(world, room.worldPosition.x + Math.random() * 7, room.worldPosition.y + 5));
		}
	}
}