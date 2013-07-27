package 
{
	import flash.display.Sprite;
	import knave.RLBuilder;
	import screens.IntroScreen;
	import knave.RL;

	public class Main extends Sprite 
	{
		public function Main():void
		{	
			addChild(new RLBuilder()
							.useTerminalWith8x8Font(100, 80)
							.useAllMovementKeys()
							.useWaitKey()
							.build(new IntroScreen()));
		}
	}
}