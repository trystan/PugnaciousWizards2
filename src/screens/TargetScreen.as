package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	public class TargetScreen implements Screen
	{
		private var callback:Function;
		private var tx:int;
		private var ty:int;
		
		public function TargetScreen(player:Player, callback:Function) 
		{
			this.tx = player.position.x;
			this.ty = player.position.y;
			this.callback = callback;
		}
		
		public function handleInput(keyEvent:KeyboardEvent):void 
		{
			switch (keyEvent.keyCode)
			{
				case 39: moveBy(1, 0); break;
				case 37: moveBy(-1, 0); break;
				case 40: moveBy(0, 1); break;
				case 38: moveBy(0, -1); break;
				case 13:
					callback(tx, ty);
					Main.exitScreen();
					break;
				default:
					trace(keyEvent.keyCode);
					Main.exitScreen();
			}
		}
		
		private function moveBy(mx:int, my:int):void 
		{
			tx += mx;
			ty += my;
		}
		
		public function refresh(terminal:AsciiPanel):void 
		{
			terminal.write("Which location?", 2, 78, 0xffffff);
			terminal.write("X", tx, ty, 0xffffff);
		}
		
		public function animateOneFrame(terminal:AsciiPanel):Boolean 
		{
			return false;
		}
	}
}