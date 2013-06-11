package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	
	public class HelpScreen extends BaseScreen
	{
		private var w:int = 0;
		private var h:int = 0;
		private var background:Color = Color.integer(0x11111f);
		
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
			"    w          y k u",
			"  a . d   or   h . l   or   arrow keys    to move",
			"    s          b j n",
			"",
			"Press ? to view this help",
			"Press 1 through 9 to cast a spell",
			"",
			"Bump into others to attack them",
			"Stand on items to pick them up",
			"",
			"Be careful with your magic and don't give up.",
		];
		
		private function draw(terminal:AsciiPanel):void
		{
			var left:int = (terminal.getWidthInCharacters() - w) / 2;
			var top:int = (terminal.getHeightInCharacters() - h) / 2;
			
			for (var x:int = 0; x < w; x++)
			for (var y:int = 0; y < h; y++)
			{
				var char:String = terminal.getCharacter(left + x, top + y);
				var fg:int = terminal.getForegroundColor(left + x, top + y);
				var bg:int = terminal.getBackgroundColor(left + x, top + y);
				
				fg = Color.integer(fg).lerp(background, 0.125).toInt();
				bg = Color.integer(bg).lerp(background, 0.125).toInt();
				
				terminal.write(char, left + x, top + y, fg, bg);
			}
			
			for (var i:int = 0; i < text.length; i++)
			{
				for (x = 0; x < text[i].length; x++)
				{
					y = i * 2;
					
					bg = terminal.getBackgroundColor(left + x, top + y);
					
					terminal.write(text[i].charAt(x), left + x + 2, top + y + 2, 0xffffff, bg);
				}
			}
		}
	}
}