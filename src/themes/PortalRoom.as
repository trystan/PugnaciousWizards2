package themes
{
	import flash.geom.Point;
	
	public class PortalRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			room.allowsVariation = false;
			
			world.addTile(room.worldPosition.x + 3, room.worldPosition.y + 3, Tile.portal);
		}
	}
}