package spells 
{
	import features.TimedFlashEffect;
	import features.TimedMeteorEffect;
	
	public class TimedMeteor implements Spell 
	{
		public function get name():String { return "Timed meteor"; }
		
		public function get description():String { return "Drop a timer. After 5 turns, a meteor will crash to the ground and destroy everything nearby."; }
		
		public function playerCast(player:Creature, callback:Function):void 
		{
			cast(player, 0, 0);
			callback();
		}
		
		public function cast(caster:Creature, x:int, y:int):void 
		{
			caster.world.addFeature(new TimedMeteorEffect(caster.world, caster.position.x, caster.position.y));
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction 
		{
			return new SpellCastAction(0.01, function():void {
				cast(ai, 0, 0);
			});
		}
	}
}