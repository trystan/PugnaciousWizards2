package spells 
{
	public class HealAndWeaken implements Spell
	{
		public function get name():String { return "Heal & weaken"; }
		
		public function get description():String
		{
			return "Reduce you maximum health and vision to fully heal yourself.";
		}
		
		public function playerCast(player:Creature, callback:Function):void 
		{
			cast(player, 0, 0);
			callback();
		}
		
		public function cast(caster:Creature, x:int, y:int):void 
		{
			caster.maxHealth -= 10;
			caster.heal(caster.maxHealth);
			caster.visionRadius--;
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction
		{
			var chance:Number = ai.maxHealth > 10 && ai.health < 15 ? 80 : 0;
			
			return new SpellCastAction(chance, function():void
			{
				cast(ai, ai.position.x, ai.position.y);
			});
		}
	}
}