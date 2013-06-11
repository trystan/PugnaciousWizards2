package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	import knave.RL;
	
	public class HelpPopupScreen extends BaseScreen
	{
		private var w:int = 0;
		private var h:int = 0;
		private var background:Color = Color.integer(0x11111f);
		private var text:Array;
		
		public function HelpPopupScreen(text:String) 
		{
			this.text = text.split("\n");
			
			bind('escape', exitScreen);
			bind('enter', exitScreen);
			
			bind('draw', draw);
			
			h = this.text.length * 2 + 3;
			for each (var line:String in this.text)
				w = Math.max(w, line.length + 4);
		}
		
		private function exitScreen(junk:*):void
		{
			exit();
			RL.current.animate();
		}
		
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