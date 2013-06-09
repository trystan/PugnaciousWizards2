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
	
	public class PlayScreen extends BaseScreen
	{
		public var player:Creature;
		public var world:World;
		public var display:WorldDisplay;
		private var animateInterval:int;
		
		public function PlayScreen(player:Player = null, world:World = null) 
		{
			if (player == null)
				player = new Player(new Point(1, 35));
				
			if (world == null)
				world = new World().addWorldGen(new WorldGen());
			
			this.player = player;
			this.world = world;
			
			world.add(player);
			
			display = new WorldDisplay(player, world);
			
			bind('up', function():void { moveBy(0, -1); } );
			bind('down', function():void { moveBy(0, 1); } );
			bind('left', function():void { moveBy(-1, 0); } );
			bind('right', function():void { moveBy(1, 0); } );
			
			bind('up left', function():void { moveBy(-1, -1); } );
			bind('up right', function():void { moveBy(1, -1); } );
			bind('down left', function():void { moveBy(-1, 1); } );
			bind('down right', function():void { moveBy(1, 1); } );
			
			bind('.', function():void { moveBy(0, 0); } );
			
			bind('1', function():void { player.castSpell(0, nextTurn); } );
			bind('2', function():void { player.castSpell(1, nextTurn); } );
			bind('3', function():void { player.castSpell(2, nextTurn); } );
			bind('4', function():void { player.castSpell(3, nextTurn); } );
			bind('5', function():void { player.castSpell(4, nextTurn); } );
			bind('6', function():void { player.castSpell(5, nextTurn); } );
			bind('7', function():void { player.castSpell(6, nextTurn); } );
			bind('8', function():void { player.castSpell(7, nextTurn); } );
			bind('9', function():void { player.castSpell(8, nextTurn); } );
			
			bind('draw', draw);
			bind('animate', animate);
			
			RL.current.interruptAnimations = false;
		}
		
		private function moveBy(mx:int, my:int):void
		{
			player.moveBy(mx, my);
			nextTurn();
		}
		
		public function nextTurn():void
		{
			world.update();
			
			if (player.health < 1)
				switchTo(new FailScreen(player, world));
			else if (world.playerHasWon)
				switchTo(new VictoryScreen(player, world));
			else
				RL.current.animate();
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			display.draw(terminal);
		}
		
		public function animate(terminal:AsciiPanel):void
		{
			draw(terminal);
			
			var didUpdate:Boolean = false;
			while (world.animationEffects.length > 0 && !didUpdate)
			{
				world.animate();
				
				if (display.drawAnimations(terminal))
					didUpdate = true;
			}
			
			if (player.health < 1)
				switchTo(new FailScreen(player, world));
			else if (world.playerHasWon)
				switchTo(new VictoryScreen(player, world));
			else if (world.animationEffects.length > 0 || didUpdate)
				RL.current.animate();
		}
	}
}