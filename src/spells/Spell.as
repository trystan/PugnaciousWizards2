package spells 
{
	public interface Spell 
	{
		function get name():String;
		function playerCast(player:Player, callback:Function):void;
		function cast(x:int, y:int):void;
	}	
}