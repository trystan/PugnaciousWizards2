package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.accessibility.AccessibilityImplementation;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import knave.BaseScreen;
	import knave.RL;
	import knave.Screen;
	import themes.TreasureFactory;
	
	public class PlayScreen extends BaseScreen
	{
		public var player:Player;
		public var world:World;
		public var display:WorldDisplay;
		private var animateInterval:int;
		
		public function PlayScreen() 
		{
			TreasureFactory.reset();
			
			var spellsForSale:Array = [];
			spellsForSale.push((TreasureFactory.random() as Scroll).spell);
			spellsForSale.push((TreasureFactory.random() as Scroll).spell);
			spellsForSale.push((TreasureFactory.random() as Scroll).spell);
			
			player = new Player(new Point(1, 19));
			world = new World().addWorldGen(new WorldGen());
			
			world.addCreature(player);
			
			display = new WorldDisplay(player, world);
			
			bind('up', moveBy, 0, -1);
			bind('down', moveBy, 0, 1);
			bind('left', moveBy, -1, 0);
			bind('right', moveBy, 1, 0);
			bind('up left', moveBy, -1, -1);
			bind('up right', moveBy, 1, -1);
			bind('down left', moveBy, -1, 1);
			bind('down right', moveBy, 1, 1);
			bind('wait', moveBy, 0, 0);
			
			bind('1', player.castSpell, 0, nextTurn);
			bind('2', player.castSpell, 1, nextTurn);
			bind('3', player.castSpell, 2, nextTurn);
			bind('4', player.castSpell, 3, nextTurn);
			bind('5', player.castSpell, 4, nextTurn);
			bind('6', player.castSpell, 5, nextTurn);
			bind('7', player.castSpell, 6, nextTurn);
			bind('8', player.castSpell, 7, nextTurn);
			bind('9', player.castSpell, 8, nextTurn);
			
			bind('?', function():void { enter(new HelpScreen()); } );
			bind('D', function():void { enter(new DiscoveriesScreen()); } );
			bind('x', 'examine');
			bind('X', 'examine');
			bind('examine', function():void { enter(new ExamineScreen(world, player)); } );
			bind('$', function():void { enter(new SpellShopScreen(player, spellsForSale)); } );
			
			bind('draw', draw);
			bind('animate', animate);
		}
		
		private function moveBy(mx:int, my:int):void
		{
			player.moveBy(mx, my);
			nextTurn();
		}
		
		private var isUpdatingPlayer:Boolean = true;
		
		public function updateOthers():void
		{
			isUpdatingPlayer = false;
			world.updateFeatures();
			world.updateCreatures();
			checkEnding();
		}
		
		public function nextTurn():void
		{
			isUpdatingPlayer = true;
			checkEnding();
		}
		
		public function checkEnding():void
		{
			if (player.health < 1)
				switchTo(new FailScreen(player, world));
			else if (world.playerHasWon)
				switchTo(new VictoryScreen(player, world));
			else
				animateOneFrame();
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			display.draw(terminal);
		}
		
		public function animate(terminal:AsciiPanel):void
		{
			var didUpdate:Boolean = false;
			while (world.animationList.length > 0 && !didUpdate)
			{
				if (display.drawAnimations(terminal))
					didUpdate = true;
					
				world.animate();
			}
			
			if (player.health < 1)
				switchTo(new FailScreen(player, world));
			else if (world.playerHasWon)
				switchTo(new VictoryScreen(player, world));
			else if (world.animationList.length > 0 || didUpdate)
				animateOneFrame();
			else if (isUpdatingPlayer)
				updateOthers();
		}
	}
}