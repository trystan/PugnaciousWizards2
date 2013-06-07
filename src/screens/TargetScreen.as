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
		private var player:Player;
		
		public function TargetScreen(player:Player, callback:Function) 
		{
			this.tx = player.position.x;
			this.ty = player.position.y;
			this.player = player;
			this.callback = callback;
			
			bind('up', function():void { moveBy(0, -1); } );
			bind('down', function():void { moveBy(0, 1); } );
			bind('left', function():void { moveBy(-1, 0); } );
			bind('right', function():void { moveBy(1, 0); } );
			bind('up left', function():void { moveBy(-1, -1); } );
			bind('up right', function():void { moveBy(1, -1); } );
			bind('down left', function():void { moveBy(-1, 1); } );
			bind('down right', function():void { moveBy(1, 1); } );
			
			bind('escape', function():void { exit(); } );
			bind('enter', function():void { callback(player, tx, ty); exit(); } );
			bind('draw', draw);
		}
		
		private function moveBy(mx:int, my:int):void 
		{
			if (!player.canSee(tx + mx, ty + my)
					|| player.world.blocksMovement(tx + mx, ty + my))
				return;
				
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