package spells 
{
	
	
	import animations.PullAndFreezeProjectile;
	import flash.geom.Point;
	import knave.Line;
	import knave.RL;
	import screens.TargetDirectionScreen;
	
	public class PullAndFreeze implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Pull & freeze"; }
		
		public function get description():String
		{
			return "Shoot a projectile that attracts and freezes anything near what it hits.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetDirectionScreen(player, cast));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			new PullAndFreezeProjectile(caster.world, caster.position.x, caster.position.y, x, y);
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{	
			if (ai.fireCounter > 0 && Math.random() < 0.5)
				return new SpellCastAction(0.0, function():void { cast(ai, 0, 0); } );
			
			var directions:Array = [[ -1, 0], [ -1, -1], [ -1, 1], [0, -1], [0, 1], [1, 0], [1, -1], [1, 1]];
			var offsets:Array;
			
			for each (offsets in directions)
			{
				var x:int = ai.position.x;
				var y:int = ai.position.y;
				var dist:int = 0;
				
				while (dist++ < ai.visionRadius)
				{
					x += offsets[0];
					y += offsets[1];

					if (dist < 4)
						continue;
					
					var c:Creature = ai.world.getCreature(x, y);
					if (c == null || c == ai)
						continue;
						
					if (!ai.canSeeCreature(c) || !ai.isEnemy(c))
						continue;
						
					return new SpellCastAction(0.8, function():void
					{
						cast(ai, offsets[0], offsets[1]);
					});
				}
			}
			
			return new SpellCastAction(0.0, function():void { });
		}
	}
}