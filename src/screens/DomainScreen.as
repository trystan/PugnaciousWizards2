package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	
	public class DomainScreen extends BaseScreen
	{
		
		
		protected function drawRecticle(terminal:AsciiPanel, x:int, y:int, fg:int = 0xffffff, bg:int = 0x101010):void
		{
			if (y > 0 && x > 0)
				terminal.write(String.fromCharCode(201), x - 1, y - 1, fg, bg);
			if (y > 0)
				terminal.write(String.fromCharCode(/*216*/ 205), x - 0, y - 1, fg, bg);
			if (y > 0 && x < 99)
				terminal.write(String.fromCharCode(187), x + 1, y - 1, fg, bg);
			
			if (x > 0)
				terminal.write(String.fromCharCode(/*215*/ 186), x - 1, y, fg, bg);
			if (x < 99)
				terminal.write(String.fromCharCode(/*215*/ 186), x + 1, y, fg, bg);
			
			if (y < 79 && x > 0)
				terminal.write(String.fromCharCode(200), x - 1, y + 1, fg, bg);
			if (y < 79)
				terminal.write(String.fromCharCode(/*216*/ 205), x - 0, y + 1, fg, bg);
			if (y < 79 && x < 99)
				terminal.write(String.fromCharCode(188), x + 1, y + 1, fg, bg);
		}
	}
}