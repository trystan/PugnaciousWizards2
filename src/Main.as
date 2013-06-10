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
		public function Main():void
		{
			var terminal:AsciiPanel = new AsciiPanel(100, 80);
			terminal.useRasterFont(AsciiPanel.codePage437_8x8, 8, 8);
			
			var rl:RL = new RL(terminal);
			rl.bind('a', 'left');
			rl.bind('d', 'right');
			rl.bind('w', 'up');
			rl.bind('s', 'down');
			rl.bind('h', 'left');
			rl.bind('j', 'down');
			rl.bind('k', 'up');
			rl.bind('l', 'right');
			rl.bind('y', 'up left');
			rl.bind('u', 'up right');
			rl.bind('b', 'down left');
			rl.bind('n', 'down right');
			rl.enter(new IntroScreen());
			
			addChild(rl);
		}
	}
}