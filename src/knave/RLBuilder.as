package knave 
{
	import com.headchant.asciipanel.AsciiPanel;
	
	public class RLBuilder 
	{
		private var rl:RL;
		
		public function useDefaultTerminal():RLBuilder2
		{
			rl = new RL(new AsciiPanel());
			
			return new RLBuilder2(rl);
		}
		
		public function useTerminalWith9x16Font(width:int, height:int):RLBuilder2
		{
			return useTerminalWithSpecificRasterFont(width, height, AsciiPanel.codePage437_9x16, 9, 16);
		}
		
		public function useTerminalWith8x8Font(width:int, height:int):RLBuilder2
		{
			return useTerminalWithSpecificRasterFont(width, height, AsciiPanel.codePage437_8x8, 8, 8);
		}
		
		public function useTerminalWithSpecificRasterFont(width:int, height:int, rasterFont:Class, charWidth:int, charHeight:int):RLBuilder2
		{
			var terminal:AsciiPanel = new AsciiPanel(width, height);
			terminal.useRasterFont(rasterFont, charWidth, charHeight);
			rl = new RL(terminal);
			
			return new RLBuilder2(rl);
		}
	}
}