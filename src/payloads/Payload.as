package payloads 
{
	public interface Payload 
	{
		function hit(creature:Creature):void;
		function hitTile(world:World, x:int, y:int):void;
	}
}