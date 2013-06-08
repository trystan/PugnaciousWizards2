package spells 
{
	import animations.MagicMissileProjectile;
	import knave.RL;
	import screens.TargetDirectionScreen;
	
	public class MagicMissile implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Magic missile"; }
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetDirectionScreen(player, cast));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			new MagicMissileProjectile(caster.world, caster.position.x, caster.position.y, x, y);
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction
		{
			return new SpellCastAction(0, function():void
			{
				new MagicMissile().cast(ai, ai.position.x, ai.position.y);
			});
		}
	}
}