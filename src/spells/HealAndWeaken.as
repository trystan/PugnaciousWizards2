package spells 
{
	public class HealAndWeaken implements Spell
	{
		public function get name():String 
		{
			return "Heal & weaken";
		}
		
		public function playerCast(player:Player, callback:Function):void 
		{
			player.maxHealth -= 10;
			player.health = player.maxHealth;
			player.visionRadius--;
			callback();
		}
		
		public function cast(x:int, y:int):void 
		{
			
		}
	}
}