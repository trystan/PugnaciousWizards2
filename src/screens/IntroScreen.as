package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class IntroScreen implements Screen
	{
		public var hero:Hero;
		public var world:World;
		public var display:WorldDisplay;
		
		private var animateInterval:int = 0;
		
		public function IntroScreen(hero:Hero = null, world:World = null) 
		{
			if (hero == null)
				hero = new Hero(new Point(1, 35));
				
			if (world == null)
				world = new World().addWorldGen(new WorldGen());
			
			this.hero = hero;
			this.world = world;
			
			world.add(hero);
			
			display = new WorldDisplay(hero, world);
			animateInterval = setInterval(animate, 1000.0 / 30);
		}
		
		private function animate():void
		{
			Main.onKeyDown(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 46, 46));
		}
		
		public function handleInput(keyEvent:KeyboardEvent):void 
		{
			if (keyEvent.keyCode == 13)
			{
				switchTo(new PlayScreen());
			}
			else
			{
				hero.update();
				world.update();
				
				if (hero.health < 1)
					switchTo(new IntroScreen());
				else if (world.playerHasWon)
					switchTo(new IntroScreen());
			}
		}
		
		public function switchTo(screen:Screen):void
		{
			clearInterval(animateInterval);
			Main.switchToScreen(screen);
		}
		
		public function refresh(terminal:AsciiPanel):void 
		{
			display.draw(terminal, "Pugnacious Wizards 2", "-- press enter to begin --");
		}
		
		public function animateOneFrame(terminal:AsciiPanel):Boolean 
		{
			return display.animateOneFrame(terminal);
		}
	}
}