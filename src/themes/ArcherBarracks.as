package themes
{
	import features.ArcherRespawn;
	import flash.geom.Point;
	
	public class ArcherBarracks implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			var blueprint:Array = [
				"0000000",
				"0111100",
				"0000010",
				"0111110",
				"1000010",
				"0111111",
				"0000000",
			];
			
			for (var ox:int = 0; ox < 7; ox++)
			for (var oy:int = 0; oy < 7; oy++)
			{
				var x:int = room.position.x * 8 + 5 + ox;
				var y:int = room.position.y * 8 + 5 + oy;
				
				var t:Tile = blueprint[oy].charAt(ox) == "0" ? Tile.floor_dark : Tile.floor_light;
				
				world.addTile(x, y, t);
			}
			
			world.addFeature(new ArcherRespawn(room, world));
		}
	}
}