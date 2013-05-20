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
			switch (world.getTile(x, y))
			{
				case Tile.door_opened: return "/";
				case Tile.door_closed: return "+";
				case Tile.wall: return "#";
				case Tile.floor: return String.fromCharCode(250);
				default: return "X";
			}
		}
		
		private function fg(x:int, y:int):int
		{
			switch (world.getTile(x, y))
			{
				case Tile.door_opened: return 0xcc9999;
				case Tile.door_closed: return 0xcc9999;
				case Tile.wall: return 0xc0c0c0;
				case Tile.floor: return 0x333333;
				default: return 0xff0000;
			}
		}
		
		private function bg(x:int, y:int):int
		{
			switch (world.getTile(x, y))
			{
				case Tile.door_opened: return 0x663333;
				case Tile.door_closed: return 0x663333;
				case Tile.wall: return 0x333333;
				case Tile.floor: return 0x090909;
				default: return 0x00ff00;
			}
		}
	}
}