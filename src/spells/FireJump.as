package spells 
{
	import animations.Explosion;
	import knave.RL;
	import screens.TargetScreen;
	
	public class FireJump implements Spell
	{
		private var player:Player;
		private var callback:Function;
		
		public function get name():String { return "Fire jump"; }
		
		public function playerCast(player:Player, callback:Function):void
		{
			this.player = player;
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast));
		}
		
		public function cast(x:int, y:int):void
		{
			player.moveTo(x, y);
			new Explosion(player.world, x, y);
			callback();
		}
	}
}