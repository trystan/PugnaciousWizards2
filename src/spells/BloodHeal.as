package spells 
{
	import animations.Flash;
	import flash.display.ColorCorrectionSupport;
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
			for (var x:int = -caster.visionRadius; x <= caster.visionRadius; x++)
			for (var y:int = -caster.visionRadius; y <= caster.visionRadius; y++)
			{
				if (!caster.canSee(x + caster.position.x, y + caster.position.y))
					continue;
				
				var blood:int = caster.world.getBlood(x + caster.position.x, y + caster.position.y);
				
				if (blood == 0)
					continue;
					
				new Flash(caster.world, x + caster.position.x, y + caster.position.y);
				
				caster.world.addBlood(x + caster.position.x, y + caster.position.y, -blood);
				caster.healBy(blood);
			}
		}
		
		private function getVisibleBloodCount(caster:Creature):int
		{
			var count:int = 0;
			for (var x:int = -caster.visionRadius; x <= caster.visionRadius; x++)
			for (var y:int = -caster.visionRadius; y <= caster.visionRadius; y++)
			{
				if (caster.canSee(x + caster.position.x, y + caster.position.y))
					count += caster.world.getBlood(x + caster.position.x, y + caster.position.y);
			}
			return count;
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction 
		{
			return new SpellCastAction(ai.health < 30 && getVisibleBloodCount(ai) > 0 ? 50 : 0, function():void {
				new BloodHeal().cast(ai, 0, 0);
			});
		}
	}
}