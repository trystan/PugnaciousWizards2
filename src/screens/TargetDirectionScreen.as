package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	public class TargetDirectionScreen implements Screen
	{
		private var callback:Function;
		
		public function TargetDirectionScreen( callback:Function) 
		{
			this.callback = callback;
		}
		
		public function handleInput(keyEvent:KeyboardEvent):void 
		{
			switch (keyEvent.keyCode)
			{
				case 39: callback(1, 0); break;
				case 37: callback(-1, 0); break;
				case 40: callback(0, 1); break;
				case 38: callback(0, -1); break;
				default:
					trace(keyEvent.keyCode);
			}
			Main.exitScreen();
		}
		
		public function refresh(terminal:AsciiPanel):void 
		{
			terminal.write("Which direction?", 2, 78, 0xffffff);
		}
		
		public function animateOneFrame(terminal:AsciiPanel):Boolean 
		{
			return false;
		}
	}
}