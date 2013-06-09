package  
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import screens.PlayScreen;
	
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
			outsideTheCastleHasGrass();
			insideTheCastleHasLightAndDarkTiles();
			castleIsMadeOfRooms();
			castleRoomsAreConnected();
			roomsCanBeDeadEnds();
			worldHasItems();
			threeDeadEndsContainPiecesOfTheAmulet();
			movingOntoAnItemPicksItUp();
			playerCanWinAfterPickingUpThreeEndPieces();
			collectingAllPiecesAndGoingToTheExitWinsTheGame();
			roomsHaveADistanceToTheBegining();
		}
		
		private function roomsHaveADistanceToTheBegining():void 
		{
			var world:World = new World().addWorldGen(new WorldGen());
			
			assertEqual(world.getRoom(5, 40).distance, 1);
		}
		
		private function collectingAllPiecesAndGoingToTheExitWinsTheGame():void 
		{
			var world:World = new World();
			var player:Player = new Player(new Point(5,5));
			world.add(player);
			player.endPiecesPickedUp = 3;
			
			assertEqual(world.playerHasWon, false);
			
			player.moveBy( -1, 0);
			player.moveBy( -1, 0);
			assertEqual(world.playerHasWon, true);
		}
		
		private function playerCanWinAfterPickingUpThreeEndPieces():void 
		{
			var world:World = new World();
			var player:Creature = new Creature(new Point(5,5), "test");
			world.add(player);
			
			world.addItem(6, 5, new EndPiece());
			world.addItem(7, 5, new EndPiece());
			world.addItem(8, 5, new EndPiece());
			
			player.moveBy(1, 0);
			player.moveBy(1, 0);
			player.moveBy(1, 0);
			assertEqual(player.hasAllEndPieces, true);
		}
		
		private function movingOntoAnItemPicksItUp():void 
		{
			var world:World = new World();
			var player:Creature = new Creature(new Point(5,5), "test");
			world.add(player);
			
			var item:EndPiece = new EndPiece();
			world.addItem(6, 5, item);
			
			assertEqual(world.items[0].item, item);
			
			player.moveBy(1, 0);
			assertEqual(world.items.length, 0);
		}
		
		private function threeDeadEndsContainPiecesOfTheAmulet():void 
		{
			// ???
		}
		
		private function worldHasItems():void 
		{
			var world:World = new World();
			var item:EndPiece = new EndPiece();
			world.addItem(1, 1, item);
			
			assertEqual(world.items[0].item, item);
		}
		
		private function roomsCanBeDeadEnds():void 
		{
			var room:Room = new Room(0, 0);
			room.isConnectedEast = true;
			
			assertEqual(room.isDeadEnd, true);
		}
		
		private function castleRoomsAreConnected():void 
		{
			var room:Room = new WorldGen().getRoom(0, 0);
			
			var isConnected:Boolean = room.isConnectedSouth || room.isConnectedEast;
			
			assertEqual(isConnected, true);
		}
		
		private function castleIsMadeOfRooms():void 
		{
			var gen:WorldGen = new WorldGen();
			
			assertNotNull(gen.getRoom(0, 0));
		}
		
		private function insideTheCastleHasLightAndDarkTiles():void 
		{
			var world:World = new World().addWorldGen(new WorldGen(true));
			
			assertEqual(world.getTile(19, 19), Tile.floor_light);
			assertEqual(world.getTile(19, 18), Tile.floor_dark);
		}
		
		private function outsideTheCastleHasGrass():void 
		{
			var world:World = new World();
			
			assertEqual(world.getTile(1, 1), Tile.grass);
		}
		
		private function bumpingIntoAClosedDoorOpensIt():void 
		{
			var world:World = new World();
			var player:Creature = new Creature(new Point(5, 5), "test");
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
			var player:Creature = new Creature(new Point(5, 5), "test");
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
			var player:Creature = new Creature(new Point(0, 0), "test");
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
			
			playscreen.trigger('right', [new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 39, 39)]);
			assertEqual(player.position.x, 6);
			assertEqual(player.position.y, 5);
			
			playscreen.trigger('left', [new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 37, 37)]);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
			
			playscreen.trigger('down', [new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 40, 40)]);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 6);
			
			playscreen.trigger('up', [new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 38, 38)]);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
		}
		
		private function movement():void 
		{
			var world:World = new World();
			var player:Creature = new Creature(new Point(5, 5), "test");
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