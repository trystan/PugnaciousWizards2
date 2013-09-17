package themes
{
	public interface RoomTheme 
	{
		function get name():String;
		function apply(room:Room, world:World):void;
	}
}