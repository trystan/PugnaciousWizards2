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
	import spells.Spell;
	import themes.TreasureFactory;
	
	public class IntroScreen extends BaseScreen
	{
		public var hero:Hero;
		public var world:World;
		public var display:WorldDisplay;
		public var spellsForSale:Array = [];
		
		public function IntroScreen() 
		{
			CurrentGameVariables.reset();
			
			spellsForSale.push((TreasureFactory.random() as Scroll).spell);
			spellsForSale.push((TreasureFactory.random() as Scroll).spell);
			spellsForSale.push((TreasureFactory.random() as Scroll).spell);
			
			hero = new Hero(new Point(1, 19));
			world = new World().addWorldGen(new WorldGen());
			
			world.addCreature(hero);
			
			display = new WorldDisplay(hero, world);
			
			bind('enter', function():void { switchTo(new PlayScreen()); } );
			bind('draw', draw);
			bind('animate', animate);
			
			animateOneFrame(true);
		}
		
		public function autoPlay():void 
		{	
			if (hero.health < 1)
				switchTo(new IntroScreen());
			else if (world.playerHasWon)
				switchTo(new IntroScreen());
			else
			{				
				doStep = false;
				
				if (hero.gold >= 20 && spellsForSale.length > 0)
					buyASpell();
				else
					world.updateCreatures();
				
				world.updateFeatures();
				animateOneFrame(true);
			}
		}
		
		private function buyASpell():void 
		{
			hero.gold -= 20;
			hero.addMagicSpell(spellsForSale.splice(0, 1)[0] as Spell);
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			display.draw(terminal);
			terminal.writeCenter("Pugnacious Wizards 2: " + CurrentGameVariables.subtitle, 1);
			terminal.writeCenter("-- press enter to begin --", 78);
		}
		
		private var doStep:Boolean = true;
		
		public function animate(terminal:AsciiPanel):void
		{
			if (doStep)
				autoPlay();
			else
				doAnimation(terminal);
		}
		
		public function doAnimation(terminal:AsciiPanel):void
		{
			var didUpdate:Boolean = false;
			while (world.animationList.length > 0 && !didUpdate)
			{
				world.animate();
				
				if (display.drawAnimations(terminal))
					didUpdate = true;
			}
			
			if (world.animationList.length == 0 || !didUpdate)
				doStep = true;
				
			animateOneFrame(true);
		}
	}
}