package spells 
{
	import animations.Explosion;
	import knave.RL;
	import payloads.Fire;
	import payloads.Poison;
	import screens.TargetScreen;
	
	public class PoisonFog implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Poison fog"; }
		
		public function get description():String
		{
			return "Create a dense fog of poison that slowly spreads and disipates.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, true));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			caster.world.addFog(x, y, 2000, new Poison());
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{
			if (Math.random() < 0.8)
				return new SpellCastAction(0.00, function():void
				{
					cast(ai, ai.position.x, ai.position.y);
				});
				
			var candidates:Array = [];
			
			ai.foreachVisibleCreature(function(other:Creature):void {
				if (ai.isEnemy(other))
					candidates.push(other);
			});
			
			if (candidates.length == 0)
				return new SpellCastAction(0.00, function():void
				{
					cast(ai, ai.position.x, ai.position.y);
				});
			
			var target:Creature = candidates[(int)(Math.random() * candidates.length)];
			
			return new SpellCastAction(0.1, function():void
			{
				cast(ai, target.position.x, target.position.y);
			});
		}
	}
}