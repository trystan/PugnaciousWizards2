package screens
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.setInterval;
	
	public class IntroScreen extends Sprite implements Screen
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
			addChild(display);
			refresh();
			
			animateInterval = setInterval(animate, 1000.0 / 100);
		}
		
		private function animate():void
		{
			Main.onKeyDown(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 46, 46));
		}
		
		public function handleInput(keyEvent:KeyboardEvent):void 
		{
			if (keyEvent.keyCode == 13)
			{
				Main.switchToScreen(new PlayScreen());
			}
			else
			{
				hero.update();
				world.update();
				refresh();
				
				if (hero.health < 1)
					Main.switchToScreen(new IntroScreen());
				else if (world.playerHasWon)
					Main.switchToScreen(new IntroScreen());
			}
		}
		
		public function refresh():void 
		{
			display.draw("Pugnacious Wizards 2", "-- press enter to begin --");
		}
		
		public function animateOneFrame():void 
		{
			display.animateOneFrame();
		}
	}
}