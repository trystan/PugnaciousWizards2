package knave 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import knave.Screen;
	
	public class RL extends Sprite implements Screen
	{
		public static var current:RL;
		
		public var screenStack:Array = [];
		public var bindings:Bindings = new Bindings();
		public var terminal:AsciiPanel;
		
		public var keyboardQueue:Array = [];
		public var isAnimating:Boolean;
		public var interruptAnimations:Boolean = false;
		public var ignoreInputDuringAnimations:Boolean = false;
		
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
		
		private function onTick(e:Event):void 
		{
			var update:Boolean = false;
			
			if (keyboardQueue.length > 0 && (!isAnimating || interruptAnimations))
			{
				update = true;
				processKeyboardEvent(keyboardQueue.shift());
			}
			
			if (isAnimating)
			{
				update = true;
				isAnimating = false;
				trigger('animate', [terminal]);
			}
			
			if (update)
				draw(terminal);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (isAnimating && ignoreInputDuringAnimations)
				return;
				
			keyboardQueue.push(e);
		}
		
		private function processKeyboardEvent(e:KeyboardEvent):void
		{
			var key:String = "";
			
			switch (e.keyCode)
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
				default: key += String.fromCharCode(e.charCode);
			}
			
			if (key.length == 0)
				return;
			
			trigger(key, [e]);
		}
		
		public function bind(message:String, messageOrHandler:Object):void
		{
			bindings.bind(message, messageOrHandler);
		}
		public function trigger(message:String, args:Array):void
		{
			bindings.trigger(message, args);
			if (screenStack.length > 0)
				screenStack[0].trigger(message, args);
		}
		
		public function animate():void
		{
			isAnimating = true;
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			for (var i:int = screenStack.length - 1; i >= 0; i--)
				screenStack[i].draw(terminal);
			terminal.paint();
		}
		
		public function enter(newScreen:Screen):void
		{
			screenStack.unshift(newScreen);
			draw(terminal);
		}
		public function exit():void
		{
			screenStack.shift();
			draw(terminal);
		}
		public function switchTo(newScreen:Screen):void
		{
			screenStack.shift();
			screenStack.unshift(newScreen);
			draw(terminal);
		}
		
		public static function bind(message:String, messageOrHandler:Object):void
		{
			current.bind(message, messageOrHandler);
		}
		public static function trigger(message:String, args:Array=null):void
		{
			current.trigger(message, args == null ? [] : args);
		}
		public static function enter(newScreen:Screen):void
		{
			current.enter(newScreen);
		}
		public static function exit():void
		{
			current.exit();
		}
		public static function switchTo(newScreen:Screen):void
		{
			current.switchTo(newScreen);
		}
		public static function animate():void
		{
			current.animate();
		}
	}
}