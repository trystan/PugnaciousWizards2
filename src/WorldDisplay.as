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
			{
				var t:String = String.fromCharCode(250);
				if (world.isDoor(x, y))
					t = "+";
				else if (world.isWall(x, y))
					t = "#";
				terminal.write(t, x, y);
			}
				
			terminal.write("@", player.position.x, player.position.y);
			
			terminal.paint();
		}
	}
}