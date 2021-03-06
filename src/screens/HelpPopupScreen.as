package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	import knave.RL;
	import knave.Text;
	
	public class HelpPopupScreen extends BaseScreen
	{
		private var w:int = 0;
		private var h:int = 0;
		private var background:int = Color.integer(0x101020).toInt();
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
		
		private function setTextLines(fullText:String, canDismiss:Boolean):void 
		{
			text = Text.wordWrap(w, fullText);
			
			while (text.length < 10)
				text.push("");
				
			if (canDismiss)
				text.push(Text.padToCenter(w, "-- press escape to dismiss all popups --"));
			text.push(Text.padToCenter(w, "-- press enter to continue --"));
		}
	}
}