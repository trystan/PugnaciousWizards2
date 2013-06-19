package spells 
{
	import animations.Flash;
	
	public class BloodHeal implements Spell 
	{
		public function get name():String { return "Blood Heal"; }
		
		public function get description():String { return "Restore health based on how much blood you see."; }
		
		
		public function playerCast(player:Creature, callback:Function):void 
		{
			cast(player, 0, 0);
			callback();
		}
		
		public function cast(caster:Creature, x:int, y:int):void 
		{
			var total:int = 0;
			
			for (var x:int = -caster.visionRadius-1; x <= caster.visionRadius+1; x++)
			for (var y:int = -caster.visionRadius-1; y <= caster.visionRadius+1; y++)
			{
				if (!caster.canSee(x + caster.position.x, y + caster.position.y))
					continue;
				
				var blood:int = caster.world.getBlood(x + caster.position.x, y + caster.position.y);
				
				if (blood == 0)
					continue;
					
				new Flash(caster.world, x + caster.position.x, y + caster.position.y);
				
				caster.world.addBlood(x + caster.position.x, y + caster.position.y, -blood);
				total += blood;
			}
			caster.healBy(total / 2);
		}
		
		private function getVisibleBloodCount(caster:Creature):int
		{
			var count:int = 0;
			for (var x:int = -caster.visionRadius-1; x <= caster.visionRadius+1; x++)
			for (var y:int = -caster.visionRadius-1; y <= caster.visionRadius+1; y++)
			{
				if (caster.canSee(x + caster.position.x, y + caster.position.y))
					count += caster.world.getBlood(x + caster.position.x, y + caster.position.y);
			}
			return count;
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction 
		{
			return new SpellCastAction(ai.health < 30 && getVisibleBloodCount(ai) > 2 ? 0.5 : 0, function():void {
				new BloodHeal().cast(ai, 0, 0);
			});
		}
	}
}