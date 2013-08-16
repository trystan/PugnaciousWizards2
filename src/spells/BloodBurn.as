package spells 
{
	import animations.Explosion;
	import animations.Flash;
	import payloads.Fire;
	
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
			caster.foreachVisibleLocation(function (vx:int, vy:int):void {
				var blood:int = caster.world.getBlood(vx, vy);
				
				if (blood == 0)
					return;
					
				new Explosion(caster.world, vx, vy, new Fire(), blood * 3, true);
				
				caster.world.addBlood(vx, vy, -blood);
			})
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction 
		{
			return new SpellCastAction(0.01, function():void {
				cast(ai, 0, 0);
			});
		}
	}
}