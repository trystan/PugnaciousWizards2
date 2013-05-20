package  
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.Sprite;
	
	public class WorldDisplay extends Sprite
	{
		public var player:Player;
		public var world:World;
		private var terminal:AsciiPanel;
		
		public function WorldDisplay(player:Player, world:World) 
		{
			this.player = player;
			this.world = world;
			
			terminal = new AsciiPanel(80, 80);
			terminal.useRasterFont(AsciiPanel.codePage437_8x8, 8, 8);
			addChild(terminal);	
		}
		
		public function draw():void
		{
			terminal.clear();
			
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				terminal.write(tile(x, y), x, y, fg(x, y), bg(x, y));
				
			terminal.write("@", player.position.x, player.position.y, 0xffffff, bg(player.position.x, player.position.y));
			
			terminal.paint();
		}
		
		private function tile(x:int, y:int):String
		{
			if (world.isOpenedDoor(x, y))
				return "/";
			if (world.isClosedDoor(x, y))
				return "+";
			else if (world.isWall(x, y))
				return "#";
			else
				return String.fromCharCode(250);
		}
		
		private function fg(x:int, y:int):int
		{
			if (world.isOpenedDoor(x, y))
				return 0xcc9999;
			if (world.isClosedDoor(x, y))
				return 0xcc9999;
			else if (world.isWall(x, y))
				return 0xc0c0c0;
			else
				return 0x333333;
		}
		
		private function bg(x:int, y:int):int
		{
			if (world.isOpenedDoor(x, y))
				return 0x663333;
			if (world.isClosedDoor(x, y))
				return 0x663333;
			else if (world.isWall(x, y))
				return 0x333333;
			else
				return 0x090909;
		}
	}
}