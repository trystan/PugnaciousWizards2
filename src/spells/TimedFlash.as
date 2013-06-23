package spells 
{
	import features.TimedFlashEffect;
	
	public class TimedFlash implements Spell 
	{
		public function get name():String { return "Timed flash"; }
		
		public function get description():String { return "Drop a timer. After 5 turns, anyone who sees it is blinded for a long time."; }
		
		public function playerCast(player:Creature, callback:Function):void 
		{
			cast(player, 0, 0);
			callback();
		}
		
		public function cast(caster:Creature, x:int, y:int):void 
		{
			caster.world.addFeature(new TimedFlashEffect(caster.world, caster.position.x, caster.position.y));
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction 
		{
			return new SpellCastAction(0.01, function():void {
				cast(ai, 0, 0);
			});
		}
	}
}