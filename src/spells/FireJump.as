package spells 
{
	import animations.Explosion;
	import knave.RL;
	import screens.TargetScreen;
	
	public class FireJump implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Fire jump"; }
		
		public function playerCast(player:Player, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast));
		}
		
		public function cast(caster:Player, x:int, y:int):void
		{
			caster.moveTo(x, y);
			new Explosion(caster.world, x, y);
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction
		{
			return new SpellCastAction(0, function():void
			{
				new FireJump().cast(ai, ai.position.x, ai.position.y);
			});
		}
	}
}