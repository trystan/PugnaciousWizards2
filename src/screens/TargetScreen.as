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
		private var player:Creature;
		private var isOk:Boolean = true;
		
		public function TargetScreen(player:Creature, callback:Function) 
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
			bind('enter', function():void { if (isOk) { callback(player, tx, ty); exit(); } } );
			bind('draw', draw);
			
			checkTarget();
		}
		
		private function moveBy(mx:int, my:int):void 
		{
			if (tx + mx < 0 || tx + mx > 79 || ty + my < 0 || ty + my > 79)
				return;
				
			tx += mx;
			ty += my;
			
			checkTarget();
		}
		
		private function checkTarget():void
		{
			isOk = player.canSee(tx, ty) 
				&& !player.world.getTile(tx, ty).blocksMovement
				&& player.world.getCreature(tx, ty) == null;
		}
		
		public function draw(terminal:AsciiPanel):void 
		{
			terminal.write("Which location?", 2, 78, 0xffffff);
			terminal.write("X", tx, ty, 0xffffff, isOk ? 0x000000 : 0xff3333);
		}
	}
}