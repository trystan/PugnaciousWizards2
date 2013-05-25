package 
{
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
	
	public class Main extends Sprite 
	{
		private static var current:Main;
		
		private var screen:Screen;
		private var animationList:Array = [];
		private var animationInterval:int = -1;
		private var hasShownLastAnimationFrame:Boolean = false;
		private var blockInput:Boolean = false;
			
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
			
			screen = new IntroScreen();
			
			addChild(screen as Sprite);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (!blockInput)
			{
				screen.handleInput(e);
				
				if (animationList.length > 0 && animationInterval == -1)
				{
					hasShownLastAnimationFrame = false;
					animationInterval = setInterval(animateOne, 1000.0 / 120);
				}
			}
		}
		
		private function animateOne(refreshFirst:Boolean = true):void
		{
			if (refreshFirst)
				screen.refresh();
			var nextAnimations:Array = [];
			
			for each (var animation:Animation in animationList)
			{
				animation.update();
				if (!animation.done)
					nextAnimations.push(animation);
			}
			
			var didUpdate:Boolean = screen.animateOneFrame();
			animationList = nextAnimations;
			
			if (animationList.length == 0)
			{
				if (hasShownLastAnimationFrame)
				{
					screen.refresh();
					clearInterval(animationInterval);
					animationInterval = -1;
					blockInput = false;
				}
				else
				{
					hasShownLastAnimationFrame = true;
				}
			}
			else if (!didUpdate)
				animateOne(false);
		}
		
		public static function switchToScreen(newScreen:Screen):void
		{
			current.removeChild(current.screen as Sprite);
			current.screen = newScreen;
			current.addChild(current.screen as Sprite);
			current.screen.refresh();
		}
		
		public static function addAnimation(animation:Animation):void
		{
			current.blockInput = true;
			current.animationList.push(animation);
		}
		
		public static function onKeyDown(e:KeyboardEvent):void 
		{
			current.onKeyDown(e);
		}
	}
}