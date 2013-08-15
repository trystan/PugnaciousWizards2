package spells 
{
	import flash.geom.Point;
	import knave.RL;
	import screens.GolemShopScreen;
	import screens.TargetScreen;
	
	public class SummonGolem implements Spell
	{
		private var callback:Function;
		private var summoned:Golem = null;
		
		public function get name():String { return "Summon golem"; }
		
		public function get description():String
		{
			return "Create a golem that will aid you and spend $ to upgrade it. You can only have one at a time.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, false, function (x:int, y:int):Boolean { return true; }));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			if (summoned != null)
				summoned.hurt(10000, "You were unsummoned. Bummer.");
				
			caster.maxHealth -= 5;
			if (caster.health > caster.maxHealth)
				caster.hurt(caster.health - caster.maxHealth, "You shared your life with too many summoned others.");
				
			var creature:Creature = caster.world.getCreature(x, y);
			
			if (creature != null)
			{
				creature.hurt(15, "You were torn to shreds by a summoning portal.");
				if (callback != null)
					callback();
			}
			else
			{
				summoned = new Golem(new Point(x, y), caster);
				caster.world.addCreature(summoned);
				if (caster is Player)
				{
					RL.current.enter(new GolemShopScreen(caster, summoned, callback));
				}
				else
				{
					if (caster.gold > 5 && Math.random() < 0.80)
					{
						summoned.isImmuneToFire = true;
						caster.gold -= 5;
					}
					if (caster.gold > 5 && Math.random() < 0.50)
					{
						summoned.isImmuneToBleeding = true;
						caster.gold -= 5;
					}
					if (caster.gold > 5 && Math.random() < 0.50)
					{
						summoned.heal(15, true);
						caster.gold -= 5;
					}
					if (caster.gold > 5 && Math.random() < 0.50)
					{
						summoned.meleeDamage += 5;
						caster.gold -= 5;
					}
					if (caster.gold > 5 && Math.random() < 0.25)
					{
						summoned.isImmuneToIce = true;
						caster.gold -= 5;
					}
					if (caster.gold > 5 && Math.random() < 0.25)
					{
						summoned.isImmuneToPoison = true;
						caster.gold -= 5;
					}
					if (caster.gold > 5 && Math.random() < 0.15)
					{
						summoned.isImmuneToBlinding = true;
						caster.gold -= 5;
					}
					if (callback != null)
						callback();
				}
			}
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{
			var chance:Number = ai.maxHealth > 25 && (summoned == null || summoned.health < 5) ? 0.5 : 0.01;
			
			return new SpellCastAction(chance, function():void
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