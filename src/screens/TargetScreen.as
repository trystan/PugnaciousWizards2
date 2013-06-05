package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import knave.BaseScreen;
	import knave.RL;
	
	public class TargetScreen extends BaseScreen
	{
		private var callback:Function;
		private var tx:int;
		private var ty:int;
		
		public function TargetScreen(player:Player, callback:Function) 
		{
			this.tx = player.position.x;
			this.ty = player.position.y;
			this.callback = callback;
			
			bind('up', function():void { moveBy(0, -1); } );
			bind('down', function():void { moveBy(0, 1); } );
			bind('left', function():void { moveBy(-1, 0); } );
			bind('right', function():void { moveBy(1, 0); } );
			
			bind('escape', function():void { exit(); } );
			bind('enter', function():void { callback(tx, ty); exit(); } );
			bind('draw', draw);
		}
		
		private function moveBy(mx:int, my:int):void 
		{
			tx += mx;
			ty += my;
		}
		
		public function draw(terminal:AsciiPanel):void 
		{
			terminal.write("Which location?", 2, 78, 0xffffff);
			terminal.write("X", tx, ty, 0xffffff);
		}
	}
}