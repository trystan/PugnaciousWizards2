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
	import knave.Color;
	import knave.RL;
	import knave.Screen;
	import themes.TreasureFactory;
	
	public class PlayScreen extends BaseScreen
	{
		public var player:Player;
		public var world:World;
		public var display:WorldDisplay;
		private var animateInterval:int;
		private var isRunning:Boolean = false;
		
		public function PlayScreen() 
		{
			CurrentGameVariables.reset();
			
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
			
			bind('1', castSpell, 0);
			bind('2', castSpell, 1);
			bind('3', castSpell, 2);
			bind('4', castSpell, 3);
			bind('5', castSpell, 4);
			bind('6', castSpell, 5);
			bind('7', castSpell, 6);
			bind('8', castSpell, 7);
			bind('9', castSpell, 8);
			
			bind('?', function():void { enter(new HelpScreen()); } );
			bind('D', function():void { enter(new DiscoveriesScreen()); } );
			bind('x', 'examine');
			bind('X', 'examine');
			bind('examine', function():void { enter(new ExamineScreen(world, player)); } );
			bind('$', function():void { enter(new SpellShopScreen(player, spellsForSale)); } );
			
			bind('mouse', function(x:int, y:int, event:Object):void {
				x = x / 8;
				y = y / 8;
				
				if (x > 79)
					return;
					
				player.path = [];
				isRunning = false;
				if (player.hasSeen(x, y)
						&& (!world.getTile(x, y, true).blocksMovement
						 || world.isClosedDoor(x, y)))
					player.pathTo(x, y);
			});
			
			bind('click', function(x:int, y:int, event:Object):void {
				x = x / 8;
				y = y / 8;
				if (x > 79)
				{
					var i:int = (y - display.spellStart.y) / 2;
					if (i >= 0 && i < player.magic.length)
						castSpell(i);
					else
					{
						i = (y - display.helpStart.y) / 2;
						switch(i)
						{
							case 0: enter(new HelpScreen());break;
							case 1: enter(new ExamineScreen(world, player));break;
							case 2: enter(new DiscoveriesScreen()); break;
						}
					}
				}
				else
				{
					isRunning = true;
					animateOneFrame(true);
				}
			});
			
			bind('draw', draw);
			bind('animate', animate);
		}
		
		override public function enter(newScreen:Screen):void 
		{
			isRunning = false;
			player.path = [];
			
			super.enter(newScreen);
		}
		
		private function moveBy(mx:int, my:int):void
		{
			isRunning = false;
			player.path = [];
			player.moveBy(mx, my);
			nextTurn();
		}
			
		private function castSpell(i:int):void
		{
			isRunning = false;
			player.castSpell(i, nextTurn);
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
				animateOneFrame(isRunning);
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			display.draw(terminal);
			terminal.writeCenter("Pugnacious Wizards 2: " + CurrentGameVariables.subtitle, 1);
			
			var hilite:Color = Color.hsv(60, 75, 75);
			
			for each (var p:Point in player.path)
			{
				var glyph:String = terminal.getCharacter(p.x, p.y);
				var fg:int = Color.integer(terminal.getForegroundColor(p.x, p.y)).lerp(hilite, 0.66).toInt();
				var bg:int = Color.integer(terminal.getBackgroundColor(p.x, p.y)).lerp(hilite, 0.66).toInt();
				
				terminal.write(glyph, p.x, p.y, fg, bg);
			}
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
			else if (isRunning)
			{
				if (player.path.length == 0)
				{
					isRunning = false;
				}
				else
				{
					player.stepOnce();
					nextTurn();
				}
			}
		}
	}
}