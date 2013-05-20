package  
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	public class Tests extends TestFramework
	{
		public function run():void
		{
			movement();
			movementKeys();
			bordersBlockMovement();
			wallsBlockMovement();
			castleIsWalledGrid();
			doorsDoNotBlockMovement();
			castleHasDoors();
			bumpingIntoAClosedDoorOpensIt();
		}
		
		private function bumpingIntoAClosedDoorOpensIt():void 
		{
			var world:World = new World();
			var player:Player = new Player(new Point(5, 5));
			world.add(player);
			world.addDoor(6,5);
			
			player.moveBy(1, 0);
			assertEqual(world.isOpenedDoor(6, 5), true);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);	
		}
		
		private function castleHasDoors():void 
		{
			var world:World = new World().addWorldGen(new WorldGen());
			
			assertEqual(world.isClosedDoor(4, 40), true);
		}
		
		private function doorsDoNotBlockMovement():void 
		{
			var world:World = new World();
			world.addDoor(6, 6);
			
			assertEqual(!world.blocksMovement(6, 6), true);
		}
		
		private function castleIsWalledGrid():void 
		{
			var world:World = new World().addWorldGen(new WorldGen());
			
			assertEqual(world.isWall(4, 4), true);
			assertEqual(world.isWall(79 - 3, 79 - 4), true);
			assertEqual(world.isWall(79 - 3, 4), true);
			assertEqual(world.isWall(4, 79 - 4), true);
		}
		
		private function wallsBlockMovement():void 
		{
			var world:World = new World();
			var player:Player = new Player(new Point(5, 5));
			world.add(player);
			world.addWall(4,5);
			world.addWall(6,5);
			world.addWall(5,4);
			world.addWall(5,6);
			
			player.moveBy(-1, 0);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
			
			player.moveBy(0, -1);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
			
			player.moveBy(1, 0);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
			
			player.moveBy(0, 1);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
		}
		
		private function bordersBlockMovement():void 
		{
			var world:World = new World();
			var player:Player = new Player(new Point(0, 0));
			world.add(player);
			
			player.moveBy(-1, 0);
			assertEqual(player.position.x, 0);
			assertEqual(player.position.y, 0);
			
			player.moveBy(0, -1);
			assertEqual(player.position.x, 0);
			assertEqual(player.position.y, 0);
			
			player.position.x = 79;
			player.position.y = 79;
			
			player.moveBy(1, 0);
			assertEqual(player.position.x, 79);
			assertEqual(player.position.y, 79);
			
			player.moveBy(0, 1);
			assertEqual(player.position.x, 79);
			assertEqual(player.position.y, 79);
		}
		
		private function movementKeys():void 
		{
			var player:Player = new Player(new Point(5, 5));
			var playscreen:PlayScreen = new PlayScreen(player, new World());
			
			playscreen.handleInput(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 39, 39));
			assertEqual(player.position.x, 6);
			assertEqual(player.position.y, 5);
			
			playscreen.handleInput(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 37, 37));
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
			
			playscreen.handleInput(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 40, 40));
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 6);
			
			playscreen.handleInput(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 38, 38));
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
		}
		
		private function movement():void 
		{
			var world:World = new World();
			var player:Player = new Player(new Point(5, 5));
			world.add(player);
			
			player.moveBy(1, 0);
			assertEqual(player.position.x, 6);
			assertEqual(player.position.y, 5);
			
			player.moveBy(-1, 0);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
			
			player.moveBy(0, 1);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 6);
			
			player.moveBy(0, -1);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
		}
	}
}