package spells 
{
	import animations.Explosion;
	import animations.Flash;
	import payloads.Fire;
	
	public class BoneSplode implements Spell 
	{
		public function get name():String { return "Bone-splode"; }
		
		public function get description():String { return "Makes all piles of bones that you can see explode."; }
		
		public function playerCast(player:Creature, callback:Function):void 
		{
			cast(player, 0, 0);
			callback();
		}
		
		public function cast(caster:Creature, x:int, y:int):void 
		{
			caster.foreachVisibleLocation(function (vx:int, vy:int):void {
				var bones:PileOfBones = caster.world.getItem(vx, vy) as PileOfBones;
				if (bones == null)
					return;
					
				new Explosion(caster.world, vx, vy, new Fire(), 25, true);
				caster.world.removeItemAt(vx, vy);
			});
		}
		
		private function getCandidateCount(caster:Creature):int
		{
			var count:int = 0;
			caster.foreachVisibleLocation(function (vx:int, vy:int):void {
				var bones:PileOfBones = caster.world.getItem(vx, vy) as PileOfBones;
				if (bones == null)
					return;
				
				for each (var xoffset:int in [-2, -1, 0, 1, 2])
				for each (var yoffset:int in [ -2, -1, 0, 1, 2])
				{
					var c:Creature = caster.world.getCreature(vx + xoffset, vy + yoffset);
					if (c == caster)
						count -= 8; // try not to burn yourself....
					else if (c != null)
						count++;	
				}
			});
			return count;
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction 
		{
			var chance:Number = Math.random() < 0.25 ? getCandidateCount(ai) / 5.0 : 0;
			
			return new SpellCastAction(chance, function():void {
				cast(ai, 0, 0);
			});
		}
	}
}