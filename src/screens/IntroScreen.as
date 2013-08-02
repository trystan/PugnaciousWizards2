package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import knave.Color;
	import knave.RL;
	import knave.BaseScreen;
	import knave.Screen;
	import themes.TreasureFactory;
	
	public class IntroScreen extends BaseScreen
	{
		public var hero:Hero;
		public var world:World;
		public var display:WorldDisplay;
		
		public function IntroScreen() 
		{
			TreasureFactory.reset();
			
			hero = new Hero(new Point(1, 19));
			world = new World().addWorldGen(new WorldGen());
			
			world.addCreature(hero);
			
			display = new WorldDisplay(hero, world);
			
			bind('enter', function():void { switchTo(new PlayScreen()); } );
			bind('step', autoPlay);
			bind('draw', draw);
			bind('animate', animate);
			
			setTimeout(RL.current.trigger, 1000, 'step');
		}
		
		public function autoPlay():void 
		{
			world.updateCreatures();
			world.updateFeatures();
			
			if (hero.health < 1)
				switchTo(new IntroScreen());
			else if (world.playerHasWon)
				switchTo(new IntroScreen());
			else
				animateOneFrame(true);
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			display.draw(terminal);
			terminal.writeCenter("Pugnacious Wizards 2, version 0.6", 1);
			terminal.writeCenter("-- press enter to begin --", 78);
		}
		
		public function animate(terminal:AsciiPanel):void
		{
			var didUpdate:Boolean = false;
			while (world.animationEffects.length > 0 && !didUpdate)
			{
				world.animate();
				
				if (display.drawAnimations(terminal))
					didUpdate = true;
			}
			
			if (world.animationEffects.length > 0 || didUpdate)
				animateOneFrame(true);
			else
				setTimeout(RL.current.trigger, 1000 / 60.0, 'step');
		}
	}
}