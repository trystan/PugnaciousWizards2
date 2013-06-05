package knave 
{
	import com.headchant.asciipanel.AsciiPanel;
	
	public class BaseScreen implements Screen
	{
		private var bindings:Bindings = new Bindings();
		
		public function bind(message:String, messageOrHandler:Object):void 
		{
			bindings.bind(message, messageOrHandler);
		}
		public function trigger(message:String, args:Array):void 
		{
			bindings.trigger(message, args);
		}
		
		public function draw(terminal:AsciiPanel):void
		{
		}
		
		public function enter(newScreen:Screen):void 
		{
			RL.enter(newScreen);
		}
		public function exit():void 
		{
			RL.exit();
		}
		public function switchTo(newScreen:Screen):void 
		{
			RL.switchTo(newScreen);
		}
	}
}