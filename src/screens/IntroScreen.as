package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import knave.RL;
	import knave.BaseScreen;
	import knave.Screen;
	
	public class IntroScreen extends BaseScreen
	{
		public var hero:Hero;
		public var world:World;
		public var display:WorldDisplay;
		
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
			
			bind('enter', function():void { switchTo(new PlayScreen()); } );
			bind('step', autoPlay);
			bind('animate', animate);
			RL.current.interruptAnimations = true;
			
			setTimeout(RL.trigger, 1000, 'step');
		}
		
		public function autoPlay():void 
		{
			hero.doAi();
			world.update();
			
			if (hero.health < 1)
				switchTo(new IntroScreen());
			else if (world.playerHasWon)
				switchTo(new IntroScreen());
			else
				RL.animate();
		}
		
		public override function draw(terminal:AsciiPanel):void
		{
			display.draw(terminal, "Pugnacious Wizards 2", "-- press enter to begin --");
			display.drawAnimations(terminal);
		}
		
		public function animate(terminal:AsciiPanel):void
		{
			trace("animate " + world.animationEffects.length);
			
			draw(terminal);
			
			var didUpdate:Boolean = false;
			while (world.animationEffects.length > 0 && !didUpdate)
			{
				world.animate();
				
				if (display.drawAnimations(terminal))
					didUpdate = true;
			}
			
			if (world.animationEffects.length > 0 || didUpdate)
			{
				terminal.paint();
				RL.animate()
			}
			else
			{
				setTimeout(RL.trigger, 1000 / 30.0, 'step');
			}
		}
	}
}