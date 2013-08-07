package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	import knave.RL;
	import spells.Spell;
	
	public class GolemShopScreen extends BaseScreen
	{
		private var w:int = 0;
		private var h:int = 0;
		private var background:int = Color.integer(0x101020).toInt();
		private var text:Array;
		private var improvementList:Array;
		private var player:Creature;
		private var golem:Golem;
		private var failedToBuy:Boolean = false;
		
		public function GolemShopScreen(player:Creature, golem:Golem, callback:Function) 
		{
			this.player = player;
			this.golem = golem;
			this.improvementList = [
				{ text:"Immunity to fire", func:function():void { golem.isImmuneToFire = true; } },
				{ text:"Immunity to ice", func:function():void { golem.isImmuneToIce = true; } },
				{ text:"Immunity to poison", func:function():void { golem.isImmuneToPoison = true; } },
				{ text:"Immunity to bleeding", func:function():void { golem.isImmuneToBleeding = true; } },
				{ text:"Immunity to blinding", func:function():void { golem.isImmuneToBlinding = true; } },
				{ text:"Extra health", func:function():void { golem.heal(15, true); } },
				{ text:"Extra melee damage", func:function():void { golem.meleeDamage += 5; } },
			];
			
			var i:int = 0;
			for each (var row:Object in improvementList)
			{
				i++;
				bind('' + i, buy, i - 1);
			}
			
			bind('escape', 'exit');
			bind('enter', 'exit')
			bind('exit', function():void { callback(); exit(); } );
			bind('draw', draw);
		}
		
		private function buy(index:int):void
		{
			failedToBuy = player.gold < 5;
				
			if (failedToBuy)
				return;
			
			if (improvementList.length <= index)
				return;
				
			improvementList.splice(index, 1)[0].func(golem);
			player.gold -= 5;
			
			if (improvementList.length == 0)
				exit();
		}
		
		private function draw(terminal:AsciiPanel):void
		{
			text = [];
			text.push(padToCenter("-- Golem shop --"));
			text.push("");
			text.push("Spend extra gold to improve your golem. Each improvement costs 5$");
			text.push("");
			var i:int = 0;
			for each (var row:Object in improvementList)
			{
				i++;
				text.push(" " + i + " " + row.text);
				text.push("");
			}
			while (text.length < 15)
				text.push("");
			
			text.push(padToCenter("-- press escape or enter to exit --"));
			text.push(padToCenter("-- press 1 through " + i + " to buy a golem improvement --"));
			
			w = 80;
			h = this.text.length * 2 + 3;
			
			var left:int = (terminal.getWidthInCharacters() - w) / 2 - 2;
			var top:int = (terminal.getHeightInCharacters() - h) / 2;
			
			for (var x:int = 0; x < w + 4; x++)
			for (var y:int = 0; y < h; y++)
				terminal.write(" ", left + x, top + y, null, background);
			
			for (i = 0; i < text.length; i++)
			{
				for (x = 0; x < text[i].length; x++)
				{
					y = i * 2
					terminal.write(text[i].charAt(x), left + x + 2, top + y + 2, 0xffffff, background);
				}
			}
			
			if (failedToBuy)
				terminal.write("You need at least 5$ to buy an improvement.", left + 2, top + y + 6, 0xffffff);
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