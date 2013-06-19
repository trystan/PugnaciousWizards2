package spells 
{
	public interface Spell 
	{
		function get name():String;
		function get description():String;
		
		function playerCast(player:Creature, callback:Function):void;
		function cast(caster:Creature, x:int, y:int):void;
		
		function aiGetAction(ai:Hero):SpellCastAction;
	}	
}