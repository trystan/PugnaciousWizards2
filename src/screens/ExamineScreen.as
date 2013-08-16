package screens 
{
	import animations.Flash;
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.MouseEvent;
	import flash.globalization.StringTools;
	import knave.BaseScreen;
	import knave.Color;
	
	public class ExamineScreen extends DomainScreen
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
			
			bind('mouse', moveTo);
			
			bind('draw', draw);
		}
		
		private function moveBy(x:int, y:int):void 
		{
			lookX = Math.max(0, Math.min(lookX + x, 79));
			lookY = Math.max(0, Math.min(lookY + y, 79));
		}
		
		private function moveTo(x:int, y:int, event:Object):void 
		{
			lookX = Math.max(0, Math.min(x / 8, 79));
			lookY = Math.max(0, Math.min(y / 8, 79));
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
			
			drawRecticle(terminal, lookX, lookY);
			
			terminal.write(text, x, y, 0xffc0c0c0);
			var spellRange:String = "";
			switch (player.magic.length)
			{
				case 0: break;
				case 1: spellRange = " or 1 for magic"; break;
				default: spellRange = " or 1 through " + player.magic.length + " for magic"; break;
			}
			terminal.write("Examine what? (use movement keys or mouse" + spellRange + ")", 2, lookY > 75 ? 71 : 78);
		}
		
		private function describe():String 
		{
			return player.describe(lookX, lookY);
		}
	}
}