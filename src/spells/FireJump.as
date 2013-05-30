package spells 
{
	import animations.Explosion;
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
			
			Main.enterScreen(new TargetScreen(player, cast));
		}
		
		public function cast(x:int, y:int):void
		{
			player.position.x = x;
			player.position.y = y;
			Main.addAnimation(new Explosion(player.world, x, y));
			callback();
		}
	}
}