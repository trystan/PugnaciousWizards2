package spells 
{
	import animations.Explosion;
	import animations.Flash;
	import payloads.Fire;
	
	public class MidasBones implements Spell 
	{
		public function get name():String { return "Midas' Bones"; }
		
		public function get description():String { return "Turn all piles of bones that you can see into gold. Skeletons turn into gold statues. Be careful though - don't get trapped by your own greed...."; }
		
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
					
				caster.world.removeItem(bones);
				caster.world.addItem(vx, vy, new Gold());
			});
			
			caster.foreachVisibleCreature(function (other:Creature):void {
				if (!(other is Skeleton))
					return;
					
				caster.world.removeCreature(other);
				caster.world.addTile(other.position.x, other.position.y, Tile.golden_statue);
			});
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction 
		{
			return new SpellCastAction(0.02, function():void {
				cast(ai, 0, 0);
			});
		}
	}
}