package payloads 
{
	public interface Payload 
	{
		function hitCreature(creature:Creature):void;
		function hitTile(world:World, x:int, y:int):void;
	}
}