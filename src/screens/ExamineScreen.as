package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	
	public class ExamineScreen extends BaseScreen
	{
		private var world:World;
		private var player:Player;
		private var lookX:int = 0;
		private var lookY:int = 0;
		private var background:Color = Color.integer(0x11111f);
		
		public function ExamineScreen(world:World, player:Player) 
		{
			this.world = world;
			this.player = player;
			this.lookX = player.position.x;
			this.lookY = player.position.y;
			
			bind('escape', exitScreen);
			bind('enter', exitScreen);
			bind('space', exitScreen);
			bind('x', exitScreen);
			bind('X', exitScreen);
			
			
			bind('up', moveBy, 0, -1);
			bind('down', moveBy, 0, 1);
			bind('left', moveBy, -1, 0);
			bind('right', moveBy, 1, 0);
			bind('up left', moveBy, -1, -1);
			bind('up right', moveBy, 1, -1);
			bind('down left', moveBy, -1, 1);
			bind('down right', moveBy, 1, 1);
			
			bind('1', describeMagic, 0);
			bind('2', describeMagic, 1);
			bind('3', describeMagic, 2);
			bind('4', describeMagic, 3);
			bind('5', describeMagic, 4);
			bind('6', describeMagic, 5);
			bind('7', describeMagic, 6);
			bind('8', describeMagic, 7);
			bind('9', describeMagic, 8);
			
			bind('draw', draw);
		}
		
		private function moveBy(x:int, y:int):void 
		{
			lookX = Math.max(0, Math.min(lookX + x, 79));
			lookY = Math.max(0, Math.min(lookY + y, 79));
		}
		
		private function describeMagic(index:int):void
		{
			if (player.magic.length > index)
			{
				var text:String = player.magic[index].name + "\n\n" + player.magic[index].description;
				enter(new HelpPopupScreen(text, false));
			}
		}
		
		private function exitScreen(junk:*):void
		{
			exit();
		}
		
		private function draw(terminal:AsciiPanel):void
		{
			var text:String = describe();
			
			var x:int = Math.max(0, Math.min(lookX - text.length / 2 + 1, 80 - text.length));
			var y:int = lookY - 3;
			
			if (y < 0)
				y = lookY + 3;
				
			var fg:int = 0xffffffff;
			var bg:int = 0xff101010;
			
			if (lookY > 0 && lookX > 0)
				terminal.write(String.fromCharCode(201), lookX - 1, lookY - 1, fg, bg);
			if (lookY > 0)
				terminal.write(String.fromCharCode(205), lookX - 0, lookY - 1, fg, bg);
			if (lookY > 0 && lookX < 99)
				terminal.write(String.fromCharCode(187), lookX + 1, lookY - 1, fg, bg);
			
			if (lookX > 0)
				terminal.write(String.fromCharCode(186), lookX - 1, lookY, fg, bg);
			if (lookX < 99)
				terminal.write(String.fromCharCode(186), lookX + 1, lookY, fg, bg);
			
			if (lookY < 79 && lookX > 0)
				terminal.write(String.fromCharCode(200), lookX - 1, lookY + 1, fg, bg);
			if (lookY < 79)
				terminal.write(String.fromCharCode(205), lookX - 0, lookY + 1, fg, bg);
			if (lookY < 79 && lookX < 99)
				terminal.write(String.fromCharCode(188), lookX + 1, lookY + 1, fg, bg);
			
			terminal.write(text, x, y, 0xffc0c0c0);
			var spellRange:String = "";
			switch (player.magic.length)
			{
				case 0: break;
				case 1: spellRange = " or 1 for magic"; break;
				default: spellRange = " or 1 through " + player.magic.length + " for magic"; break;
			}
			terminal.write("Examine what? (movement keys" + spellRange + ")", 2, lookY > 75 ? 71 : 78);
		}
		
		private function describe():String 
		{			
			if (!player.hasSeen(lookX, lookY))
				return "Unknown";
			
			if (!player.canSee(lookX, lookY))
			{
				var memory:String = player.memory(lookX, lookY).name;
				
				return memory.charAt(0).toUpperCase() + memory.substr(1) + " (from memory)";
			}
			
			var text:String = "";
			
			var creature:Creature = world.getCreature(lookX, lookY);
			if (creature != null)
			{
				text += creature.type;
				
				var attribs:Array = []
				if (creature.fireCounter > 0)
					attribs.push("burning");
					
				if (creature.freezeCounter > 0)
					attribs.push("frozen");
				
				if (creature.bleedingCounter > 0)
					attribs.push("bleeding");
					
				if (creature.poisonCounter > 0)
					attribs.push("poisoned");
					
				if (creature.blindCounter > 0)
					attribs.push("blind");
				
				if (!player.isEnemy(creature) && player != creature)
					attribs.push("friendly (" + String.fromCharCode(3) + " " + creature.health + "/" + creature.maxHealth + ")");
					
				if (attribs.length > 0)
					text += " (" + attribs.join(", ") + ")"
					
				text += " standing on ";
			}
			
			
			var item:Item = world.getItem(lookX, lookY);
			if (item != null)
				text += item.name + " laying on ";
			
			switch (world.getBlood(lookX, lookY) / 3)
			{
				case 0: break;
				case 1: text += "blood splattered "; break;
				case 2: text += "bloody "; break;
				default: text += "blood covered "; break;
			}
			
			text += world.getTile(lookX, lookY).name;
			
			return text.charAt(0).toUpperCase() + text.substr(1);
		}
	}
}