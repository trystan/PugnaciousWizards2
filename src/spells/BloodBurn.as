package spells 
{
	import animations.Explosion;
	import animations.Flash;
	
	public class BloodBurn implements Spell 
	{
		public function get name():String { return "Blood Burn"; }
		
		public function get description():String { return "Ignite any blood you see."; }
		
		
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
					
				new Explosion(caster.world, x + caster.position.x, y + caster.position.y, blood * 3, true);
				
				caster.world.addBlood(x + caster.position.x, y + caster.position.y, -blood);
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
			return new SpellCastAction(0.1, function():void {
				new BloodBurn().cast(ai, 0, 0);
			});
		}
	}
}