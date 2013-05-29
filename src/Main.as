package 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.text.StaticText;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import animations.Animation;
	import screens.Screen;
	import screens.IntroScreen;
	import screens.TargetScreen;
	
	public class Main extends Sprite 
	{
		private static var current:Main;
		
		private var screenStack:Array = [];
		private var animationList:Array = [];
		private var animationInterval:int = -1;
		private var hasShownLastAnimationFrame:Boolean = false;
		private var blockInput:Boolean = false;
		private var terminal:AsciiPanel;
			
		public function Main():void 
		{
			if (!runTests())
				return;
			
			current = this;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function runTests():Boolean
		{
			var tests:Tests = new Tests();
			tests.run();
			if (tests.failed)
			{
				var text:TextField = new TextField();
				text.text = tests.message;
				text.width = text.textWidth + 5;
				addChild(text);
			}
			return tests.passed;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			terminal = new AsciiPanel(100, 80);
			terminal.useRasterFont(AsciiPanel.codePage437_8x8, 8, 8);
			addChild(terminal);
			
			enterScreen(new IntroScreen());
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (!blockInput)
			{
				screenStack[0].handleInput(e);
				redraw();
			
				if (animationList.length > 0)
					animateOneFrame();
			}
		}
		
		private function redraw():void
		{
			for (var i:int = screenStack.length - 1; i >= 0; i--)
				screenStack[i].refresh(terminal);
			terminal.paint();
		}
		
		private function animateOneFrame(redrawFirst:Boolean = false):void
		{
			clearInterval(animationInterval);
			
			if (redrawFirst)
				redraw();
				
			var didUpdate:Boolean = false;
			
			while (animationList.length > 0 && !didUpdate)
			{
				var nextAnimations:Array = [];
				for each (var animation:Animation in animationList)
				{
					animation.update();
					if (!animation.done)
						nextAnimations.push(animation);
				}
				animationList = nextAnimations;
				didUpdate = screenStack[0].animateOneFrame(terminal);
			}
			
			if (animationList.length == 0)
				blockInput = false;
			else if (didUpdate)
				animateNextFrame();
		}
		
		private function animateNextFrame():void
		{
			animationInterval = setInterval(animateOneFrame, 1000.0 / 60, true);
		}
		
		public function switchToScreen(newScreen:Screen):void
		{
			screenStack[0] = newScreen;
			screenStack[0].refresh(terminal);	
		}
		
		public function enterScreen(newScreen:Screen):void 
		{
			screenStack.unshift(newScreen);
			screenStack[0].refresh(terminal);
		}
		
		public function exitScreen():void 
		{
			screenStack.shift();
			screenStack[0].refresh(terminal);
		}
		
		public function addAnimation(animation:Animation):void
		{
			blockInput = true;
			animationList.push(animation);
		}
		
		public static function switchToScreen(newScreen:Screen):void
		{
			current.switchToScreen(newScreen);
		}
		
		static public function enterScreen(newScreen:Screen):void 
		{
			current.enterScreen(newScreen);
		}
		
		static public function exitScreen():void 
		{
			current.exitScreen();
		}
		
		public static function addAnimation(animation:Animation):void
		{
			current.addAnimation(animation);
		}
		
		public static function onKeyDown(e:KeyboardEvent):void 
		{
			current.onKeyDown(e);
		}
	}
}