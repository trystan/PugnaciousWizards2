package spells 
{
	import animations.Explosion;
	import knave.RL;
	import payloads.Ice;
	import screens.TargetScreen;
	
	public class Winter implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Winter"; }
		
		public function get description():String
		{
			return "Freeze a lot of stuff - probably including yourself.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, false));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			new Explosion(caster.world, x, y, new Ice(), 7 * 7 * 4, true);
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction
		{	
			return new SpellCastAction(ai.fireCounter > 0 ? 0.1 : 0.01, function():void
			{
				cast(ai, ai.position.x, ai.position.y);
			});
		}
	}
}