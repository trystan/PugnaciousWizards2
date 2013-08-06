package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	import knave.RL;
	import knave.Text;
	import spells.Spell;
	
	public class SpellShopScreen extends BaseScreen
	{
		private var w:int = 0;
		private var h:int = 0;
		private var background:Color = Color.integer(0x11111f);
		private var text:Array;
		private var spellList:Array;
		private var player:Creature;
		private var failedToBuy:Boolean = false;
		
		public function SpellShopScreen(player:Creature, spellList:Array) 
		{
			this.player = player;
			this.spellList = spellList;
			
			w = 80;
			text = [];
			text.push(padToCenter("-- Spell shop --"));
			text.push("");
			text.push("Spend extra gold to gain new spells. Each spell cost 20$");
			text.push("");
			var i:int = 0;
			for each (var spell:Spell in spellList)
			{
				i++;
				text.push(" " + i + " " + spell.name);
				addSpell(spell.description, text);
				text.push("");
				bind('' + i, buy, i - 1); 
			}
			while (text.length < 15)
				text.push("");
				
			text.push(padToCenter("-- press escape to cancel --"));
			text.push(padToCenter("-- press 1 through " + i + " to buy a spell --"));
			
			h = this.text.length * 2 + 3;
			
			bind('escape', 'exit');
			bind('enter', 'exit')
			bind('exit', function():void { exit(); } );
			bind('draw', draw);
		}
		
		private function addSpell(fullText:String, text:Array):void
		{
			for each (var line:String in Text.wordWrap(w, fullText))
				text.push("   " + line);
		}
		
		private function buy(index:int):void
		{
			failedToBuy = player.gold < 20;
				
			if (failedToBuy)
				return;
			
			var spell:Spell = spellList[index];
			player.addMagicSpell(spell);
			spellList.splice(index, 1);
			player.gold -= 20;
			exit();
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
			
			if (failedToBuy)
				terminal.write("You need at least 20$ to buy a spell.", left + 2, top + y + 6, 0xffffff, bg);
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