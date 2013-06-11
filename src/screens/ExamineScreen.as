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
			
			
			bind('up', function():void { moveBy(0, -1); } );
			bind('down', function():void { moveBy(0, 1); } );
			bind('left', function():void { moveBy(-1, 0); } );
			bind('right', function():void { moveBy(1, 0); } );
			bind('up left', function():void { moveBy(-1, -1); } );
			bind('up right', function():void { moveBy(1, -1); } );
			bind('down left', function():void { moveBy(-1, 1); } );
			bind('down right', function():void { moveBy(1, 1); } );
			
			bind('draw', draw);
		}
		
		private function moveBy(x:int, y:int):void 
		{
			lookX = Math.max(0, Math.min(lookX + x, 79));
			lookY = Math.max(0, Math.min(lookY + y, 79));
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
			terminal.write("Examine what?", 2, lookY > 75 ? 71 : 78);
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
			
			var creature:Creature = world.getCreatureAt(lookX, lookY);
			if (creature != null)
				text += creature.type + " standing on ";
				
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