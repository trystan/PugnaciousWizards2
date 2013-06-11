package knave 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class RL extends Sprite implements Screen
	{
		public static var current:RL;
		
		private var screenStack:Array = [];
		private var bindings:Bindings = new Bindings();
		private var terminal:AsciiPanel;
		private var keyboardEvent:KeyboardEvent = null;
		private var isAnimating:Boolean = false;
		
		public var interruptAnimations:Boolean = false;
		
		public function RL(terminal:AsciiPanel)
		{
			current = this;
				
			this.terminal = terminal;
			addChild(terminal);
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(Event.ENTER_FRAME, onTick);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			keyboardEvent = e;
		}
		
		private function onTick(e:Event):void 
		{
			var update:Boolean = false;
			
			if (keyboardEvent != null && (!isAnimating || interruptAnimations))
			{
				update = true;
				processKeyboardEvent();
			}
			else
			{
				keyboardEvent = null;
			}
			
			if (isAnimating)
			{
				update = true;
				isAnimating = false;
				trigger('animate', [terminal]);
			}
			
			if (update)
				draw();
		}
		
		private function processKeyboardEvent():void
		{
			if (keyboardEvent == null)
				return;
				
			var key:String = "";
			var event:KeyboardEvent = keyboardEvent;
			
			keyboardEvent = null;
			
			// see http://www.dakmm.com/?p=272
			switch (event.keyCode)
			{
				case 38: key += "up"; break;
				case 39: key += "right"; break;
				case 40: key += "down"; break;
				case 37: key += "left"; break;
				case 13: key += "enter"; break;
				case 32: key += "space"; break;
				case 8: key += "backspace"; break;
				case 9: key += "tab"; break;
				case 27: key += "escape"; break;
				case 27: key += "caps lock"; break;
				case 16: return; // shift
				case 96: key += "numpad 0"; break;
				case 97: key += "numpad 1"; break;
				case 98: key += "numpad 2"; break;
				case 99: key += "numpad 3"; break;
				case 100: key += "numpad 4"; break;
				case 101: key += "numpad 5"; break;
				case 102: key += "numpad 6"; break;
				case 103: key += "numpad 7"; break;
				case 104: key += "numpad 8"; break;
				case 105: key += "numpad 9"; break;
				default: key += String.fromCharCode(event.charCode);
			}
			
			if (key.length == 0)
				return;
			
			trigger(key, [event]);
		}
		
		private function draw():void
		{
			for (var i:int = screenStack.length - 1; i >= 0; i--)
				screenStack[i].trigger('draw', [terminal]);
			terminal.paint();
		}
		
		public function bind(message:String, messageOrHandler:Object):void
		{
			bindings.bind(message, messageOrHandler);
		}
		public function trigger(message:String, args:Array=null):void
		{
			bindings.trigger(message, args);
			if (screenStack.length > 0)
				screenStack[0].trigger(message, args);
		}
		
		public function animate():void
		{
			isAnimating = true;
		}
		
		public function enter(newScreen:Screen):void
		{
			screenStack.unshift(newScreen);
			draw();
		}
		public function exit():void
		{
			screenStack.shift();
			draw();
		}
		public function switchTo(newScreen:Screen):void
		{
			screenStack.shift();
			screenStack.unshift(newScreen);
			draw();
		}
	}
}