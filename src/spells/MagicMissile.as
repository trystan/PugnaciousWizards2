package spells 
{
	import animations.MagicMissileProjectile;
	import knave.RL;
	import screens.TargetDirectionScreen;
	
	public class MagicMissile implements Spell
	{
		private var player:Player;
		private var callback:Function;
		
		public function get name():String { return "Magic missile"; }
		
		public function playerCast(player:Player, callback:Function):void
		{
			this.player = player;
			this.callback = callback;
			
			RL.current.enter(new TargetDirectionScreen(cast));
		}
		
		public function cast(x:int, y:int):void
		{
			new MagicMissileProjectile(player.world, player.position.x, player.position.y, x, y);
			callback();
		}
	}
}