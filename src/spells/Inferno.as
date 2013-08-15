package spells 
{
	import animations.Explosion;
	import knave.RL;
	import payloads.Fire;
	import payloads.Ice;
	import screens.TargetScreen;
	
	public class Inferno implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Inferno"; }
		
		public function get description():String
		{
			return "Burn a lot of stuff - probably including yourself.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, function (x:int, y:int):Boolean {
				return player.canSee(x, y)
					&& !player.world.getTile(x, y, true).blocksMovement
			}));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			if (caster.canSee(x, y))
				new Explosion(caster.world, x, y, new Fire(), 7 * 7 * 4, true);
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{	
			if (Math.random() < 0.9)
				return new SpellCastAction(0.0, function():void
				{
				});

			var candidates:Array = [];
			ai.foreachVisibleCreature(function(other:Creature):void {
				if (other.isEnemy(ai) || ai.isEnemy(other))
					candidates.push(other);
			});
			
			if (candidates.length > 0)
			{
				var other:Creature = candidates[(int)(Math.random() * candidates.length)];
				return new SpellCastAction(other.fireCounter > 5 ? 0.33 : 0.66, function():void
				{
					cast(ai, other.position.x, other.position.y);
				});
			}
			
			return new SpellCastAction(0.0, function():void
			{
			});
		}
	}
}