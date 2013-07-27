package spells 
{
	import animations.Explosion;
	import animations.Flash;
	import flash.geom.Point;
	import payloads.Fire;
	
	public class BloodJellies implements Spell 
	{
		public function get name():String { return "Blood Jellies"; }
		
		public function get description():String { return "Turn any blood you see into jelly minions. Kind of gross."; }
		
		
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
				
				caster.world.addCreature(new BloodJelly(new Point(vx, vy), caster, blood * 4));
				
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