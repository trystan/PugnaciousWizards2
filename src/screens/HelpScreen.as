package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	
	public class HelpScreen extends BaseScreen
	{
		private var w:int = 0;
		private var h:int = 0;
		private var background:int = Color.integer(0x101020).toInt();
		
		public function HelpScreen() 
		{
			bind('escape', exitScreen);
			bind('enter', exitScreen);
			bind('space', exitScreen);
			bind('?', exitScreen);
			
			bind('draw', draw);
			
			h = text.length * 2 + 4;
			for each (var line:String in text)
				w = Math.max(w, line.length + 4);
		}
		
		private function exitScreen(junk:*):void
		{
			exit();
		}
		
		private var text:Array = [
			"Pugnacious Wizards 2",
			"",
			"Find the three pieces of the amulet and escape the castle to win.",
			"",
			"    w          y k u          numpad ",
			"  a . d   or   h . l   or   arrow keys   to move",
			"    s          b j n           mouse ",
			"",
			"Press $ to buy spells",
			"Press ? to view this help",
			"Press x to examine your surroundings",
			"Press D to view what spells you've discovered",
			"Press 1 through 9 to cast that spell",
			"",
			"Bump into others to attack them",
			"Stand on gold, scrolls, and amulet pieces to pick them up",
			"",
			"  Be careful with your magic and don't give up.",
		];
		
		private function draw(terminal:AsciiPanel):void
		{
			var left:int = (terminal.getWidthInCharacters() - w) / 2;
			var top:int = (terminal.getHeightInCharacters() - h) / 2;
			
			for (var x:int = 0; x < w + 4; x++)
			for (var y:int = 0; y < h; y++)
				terminal.write(" ", left + x, top + y, null, background);
			
			for (var i:int = 0; i < text.length; i++)
			{
				for (x = 0; x < text[i].length; x++)
				{
					y = i * 2
					terminal.write(text[i].charAt(x), left + x + 2, top + y + 2, 0xffffff, background);
				}
			}
		}
	}
}