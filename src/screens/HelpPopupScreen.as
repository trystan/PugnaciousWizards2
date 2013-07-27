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
		
		public function HelpPopupScreen(text:String, canDismiss:Boolean = true) 
		{
			w = 60;
			setTextLines(text, canDismiss);
			h = this.text.length * 2 + 3;
			
			bind('escape', function ():void {
				if (canDismiss)
					HelpSystem.showHelpPopups = false;
				exitScreen("this is junk");
			});
			bind('enter', exitScreen);
			
			bind('draw', draw);
		}
		
		private function exitScreen(junk:*):void
		{
			exit();
			animateOneFrame();
		}
		
		private function draw(terminal:AsciiPanel):void
		{
			var left:int = (terminal.getWidthInCharacters() - w) / 2 - 2;
			var top:int = (terminal.getHeightInCharacters() - h) / 2;
			
			for (var x:int = 0; x < w + 4; x++)
			for (var y:int = 0; y < h; y++)
			{
				var char:String = terminal.getCharacter(left + x, top + y);
				var fg:int = terminal.getForegroundColor(left + x, top + y);
				var bg:int = terminal.getBackgroundColor(left + x, top + y);
				
				fg = Color.integer(fg).lerp(background, 0.10).toInt();
				bg = Color.integer(bg).lerp(background, 0.10).toInt();
				
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
		
		private function setTextLines(fullText:String, canDismiss:Boolean):void 
		{
			text = [];
			for each (var line:String in fullText.split("\n"))
			{
				if (line.length == 0)
					text.push("");
				
				while (line.length > w)
				{
					text.push(line.substr(0, w));
					line = line.substr(w);
				}
				while (line.length > 0 && line.charAt(0) == " ")
					line = line.substr(1);
					
				if (line.length > 0)
					text.push(line);
			}
			
			text.push("");
			text.push("");
			if (canDismiss)
				text.push(padToCenter("-- press escape to dismiss all popups --"));
			text.push(padToCenter("-- press enter to continue --"));
		}
		
		private function padToCenter(line:String):String
		{
			var left:int = (w - line.length) / 2;
			var right:int = w - line.length;
			
			var i:int = 0;
			for (i = 0; i < left; i++)
				line = " " + line;
			for (i = 0; i < right; i++)
				line = line + " ";
				
			if (line.length >= w)
				line = line.substr(0, w);
				
			return line;
		}
	}
}