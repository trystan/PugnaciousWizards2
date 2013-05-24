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
	
	public class Main extends Sprite 
	{
		private static var current:Main;
		
		private var screen:Screen;
		private var animations:Array = [];
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
			
			screen = new PlayScreen();
			
			addChild(screen as Sprite);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (!blockInput)
			{
				screen.handleInput(e);
				
				if (animations.length > 0 && animationInterval == -1)
				{
					hasShownLastAnimationFrame = false;
					animationInterval = setInterval(animateOne, 1000.0 / 60);
				}
			}
		}
		
		private function animateOne():void
		{
			screen.refresh();
			blockInput = true;
			var nextAnimations:Array = [];
			
			for each (var animation:Arrow in animations)
			{
				animation.update();
				if (!animation.done)
					nextAnimations.push(animation);
			}
			
			screen.animateOneFrame();
			animations = nextAnimations;
			
			if (animations.length == 0)
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
		}
		
		public static function switchToScreen(newScreen:Screen):void
		{
			current.removeChild(current.screen as Sprite);
			current.screen = newScreen;
			current.addChild(current.screen as Sprite);
			current.screen.refresh();
		}
		
		public static function addAnimation(arrow:Arrow):void
		{
			current.animations.push(arrow);
		}
	}
}