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
	import screens.IntroScreen;
	import knave.RL;
	import knave.Screen;
	
	public class Main extends Sprite 
	{
		private static var current:Main;
		
		private var rl:RL;
		
		private var animationList:Array = [];
		private var animationInterval:int = -1;
		private var blockInput:Boolean = false;
		private var terminal:AsciiPanel;
			
		public function Main():void 
		{
			terminal = new AsciiPanel(100, 80);
			terminal.useRasterFont(AsciiPanel.codePage437_8x8, 8, 8);
			
			rl = new RL(terminal);
			rl.bind('a', 'left');
			rl.bind('d', 'right');
			rl.bind('w', 'up');
			rl.bind('s', 'down');
			rl.bind('redraw', function():void { rl.draw(terminal); } );
			rl.bind('reanimate', function():void { rl.trigger('animate', [terminal]); } );
			rl.enter(new IntroScreen());
			
			addChild(rl);
			
			//if (!runTests())
			//	return;
			
			current = this;
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
	}
}