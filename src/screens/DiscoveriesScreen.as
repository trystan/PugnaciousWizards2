package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	import knave.Text;
	import spells.Spell;
	import themes.TreasureFactory;
	
	public class DiscoveriesScreen extends BaseScreen
	{
		private var w:int = 0;
		private var h:int = 0;
		private var background:int = Color.integer(0x101020).toInt();
		
		private var text:Array;
		
		public function DiscoveriesScreen() 
		{
			bind('escape', exitScreen);
			bind('enter', exitScreen);
			bind('space', exitScreen);
			bind('?', exitScreen);
			
			bind('draw', draw);
			
			var lines:Array = text = ["Discovered spells", ""];
			
			var list:Array = TreasureFactory.allSpells.slice();
			list.sortOn("name");
			
			for each (var spell:Spell in list)
			{
				if (Globals.hasDiscoveredSpell(spell))
					lines.push(spell.name);
				else
					lines.push("???");
			}
			
			text = Text.wordWrap(60, lines.join("\n"));
			
			w = 60;
			h = text.length * 2 + 4;
			
			text.push(Text.padToCenter(w, "-- press enter to continue --"));
		}
		
		private function exitScreen(junk:*):void
		{
			exit();
		}
		
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