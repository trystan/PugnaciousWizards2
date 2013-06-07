package spells 
{
	public interface Spell 
	{
		function get name():String;
		function playerCast(player:Player, callback:Function):void;
		function cast(caster:Player, x:int, y:int):void;
		
		function aiGetAction(ai:Hero):SpellCastAction;
	}	
}