package themes
{
	import features.CastleFeature;
	import features.GuardRespawn;
	import flash.geom.Point;
	
	public class GuardBarracks implements RoomTheme
	{
		public function get name():String { return "Guard barracks"; }
		
		public function apply(room:Room, world:World):void
		{
			room.allowsVariation = false;
			
			var blueprint:Array = [
				"0000000",
				"0011101",
				"0100010",
				"0100010",
				"0011110",
				"0000010",
				"0111100",
			];
			
			for (var ox:int = 0; ox < 7; ox++)
			for (var oy:int = 0; oy < 7; oy++)
			{
				var x:int = room.position.x * 8 + 5 + ox;
				var y:int = room.position.y * 8 + 5 + oy;
				
				var t:Tile = blueprint[oy].charAt(ox) == "0" ? Tile.floor_dark : Tile.floor_light;
				
				world.addTile(x, y, t);
			}
			
			var f:CastleFeature = new GuardRespawn(room, world);
			room.roomFeatures.push(f);
			world.addFeature(f);
		}
	}
}