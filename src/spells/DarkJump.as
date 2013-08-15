package spells 
{
	import animations.Explosion;
	import knave.RL;
	import payloads.Fire;
	import screens.TargetScreen;
	
	public class DarkJump implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Dark jump"; }
				
		public function get description():String
		{
			return "Teleport to any tile you haven't seen yet - may end up stuck in a wall.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, false, function(x:int, y:int):Boolean {
				return !player.hasSeen(x, y);
			}));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			if (caster.hasSeen(x, y))
				return;
			
			var t:Tile = caster.world.getTile(x, y, true);
			var c:Creature = caster.world.getCreature(x, y);
			
			caster.moveTo(x, y);
			
			if (t.blocksMovement)
			{
				caster.hurt(50, "Teleported into a solid " + t.name + ".");
				caster.bleed(25);
			}
			
			if (c != null)
			{
				c.hurt(25, "A " + caster.type + " blindly teleported into you.");
				c.bleed(25);
				caster.hurt(25, "Blindly teleported into a " + c.type + ".");
				caster.bleed(25);
			}
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{
			return new SpellCastAction(0, function():void
			{
			});
		}
	}
}