package spells 
{
	import animations.Explosion;
	import animations.Flash;
	
	public class BoneSplode implements Spell 
	{
		public function get name():String { return "Blood-splode"; }
		
		public function get description():String { return "Makes all piles of bones that you can see explode."; }
		
		
		public function playerCast(player:Creature, callback:Function):void 
		{
			cast(player, 0, 0);
			callback();
		}
		
		public function cast(caster:Creature, x:int, y:int):void 
		{
			for (var x:int = -caster.visionRadius-1; x <= caster.visionRadius+1; x++)
			for (var y:int = -caster.visionRadius-1; y <= caster.visionRadius+1; y++)
			{
				if (!caster.canSee(x + caster.position.x, y + caster.position.y))
					continue;
				
				var bones:PileOfBones = caster.world.getItem(x + caster.position.x, y + caster.position.y) as PileOfBones;
				if (bones == null)
					continue;
					
				new Explosion(caster.world, x + caster.position.x, y + caster.position.y, 13, true);
				caster.world.removeItem(x + caster.position.x, y + caster.position.y);
			}
		}
		
		private function getCandidateCount(caster:Creature):int
		{
			var count:int = 0;
			for (var x:int = -caster.visionRadius-1; x <= caster.visionRadius+1; x++)
			for (var y:int = -caster.visionRadius-1; y <= caster.visionRadius+1; y++)
			{
				if (!caster.canSee(x + caster.position.x, y + caster.position.y))
					continue;
				
				if (x >= -2 || x <= 2 || y <= -2 || y <= 2)
					continue;
					
				var bones:PileOfBones = caster.world.getItem(x + caster.position.x, y + caster.position.y) as PileOfBones;
				if (bones == null)
					continue;
				
				for each (var xoffset:int in [-2, -1, 0, 1, 2])
				for each (var yoffset:int in [ -2, -1, 0, 1, 2])
				{
					if (caster.world.getCreature(x + caster.position.x + xoffset, y + caster.position.y + yoffset) != null)
						count++;	
				}
			}
			return count;
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction 
		{
			return new SpellCastAction(getCandidateCount(ai) / 5.0, function():void {
				cast(ai, 0, 0);
			});
		}
	}
}