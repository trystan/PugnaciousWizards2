package spells 
{
	import animations.Explosion;
	import animations.TelekeneticMovement;
	import knave.RL;
	import payloads.Fire;
	import screens.TargetDirectionScreen;
	import screens.TargetScreen;
	
	public class Telekenesis implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Telekenesis"; }
		
		public function get description():String
		{
			return "Throw creatures and items around with the power of your mind.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, function(x:int, y:int):Boolean {
				return player.canSee(x, y) 
					&& (player.world.getItem(x, y) != null || player.world.getCreature(x, y) != null);
			}));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			RL.current.enter(new TargetDirectionScreen(caster, function(c:Creature, dx:int, dy:int):void {
				castReal(c, x, y, dx, dy);
			}));
		}
		
		public function castReal(caster:Creature, x:int, y:int, dx:int, dy:int):void
		{
			var c:Creature = caster.world.getCreature(x, y);
			var i:Item = caster.world.getItem(x, y);
			
			if (c != null)
				new TelekeneticMovement(caster, caster.world, x, y, dx, dy, c);
			
			if (i != null)
				new TelekeneticMovement(caster, caster.world, x, y, dx, dy, i);
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{
			var directions:Array = [[ -1, 0], [ -1, -1], [ -1, 1], [0, -1], [0, 1], [1, 0], [1, -1], [1, 1]];
			var offsets:Array;
			
			for each (offsets in directions)
			{
				var c:Creature = ai.world.getCreature(ai.position.x + offsets[0], ai.position.y + offsets[1]);
				if (c == null || c == ai)
					continue;
					
				if (!ai.canSeeCreature(c) || !ai.isEnemy(c))
					continue;
					
				return new SpellCastAction(0.9, function():void
				{
					castReal(ai, ai.position.x + offsets[0], ai.position.y + offsets[1], offsets[0], offsets[1]);
				});
			}
			
			for each (offsets in directions)
			{
				var x:int = ai.position.x;
				var y:int = ai.position.y;
				var dist:int = 0;
				
				while (dist++ < 8)
				{
					x += offsets[0];
					y += offsets[1];

					var item:Item = ai.world.getItem(x, y);
					if (item == null || !item.canBePickedUpBy(ai))
						continue;
						
					if (!ai.canSee(x, y))
						continue;
						
					return new SpellCastAction(0.8, function():void
					{
						castReal(ai, x, y, -offsets[0], -offsets[1]);
					});
				}
			}
			
			return new SpellCastAction(0, function():void
			{
				castReal(ai, ai.position.x, ai.position.y, 1, 0);
			});
		}
	}
}