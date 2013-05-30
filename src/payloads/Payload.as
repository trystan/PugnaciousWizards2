package payloads 
{
	public interface Payload 
	{
		function hit(creature:Player):void;
		function hitTile(world:World, x:int, y:int):void;
	}
}