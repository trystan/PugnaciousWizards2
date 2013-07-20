package spells 
{
	import animations.Explosion;
	import knave.RL;
	import payloads.Fire;
	import payloads.Healing;
	import screens.TargetScreen;
	
	public class HealingFog implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Healing fog"; }
		
		public function get description():String
		{
			return "Create a dense fog of healing magic that slowly spreads and disipates.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, true));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			caster.world.addFog(x, y, 2000, new Healing());
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction
		{
			return new SpellCastAction(0.01, function():void
			{
				var x:int = -1;
				var y:int = -1;
				var tries:int = 0;
				
				while (!ai.canSee(x, y) && tries++ < 100)
				{
					x = ai.position.x + (Math.random() * ai.visionRadius * 2) - ai.visionRadius; 
					y = ai.position.y + (Math.random() * ai.visionRadius * 2) - ai.visionRadius;
				}
				
				if (ai.canSee(x, y))
					cast(ai, x, y);
			});
		}
	}
}