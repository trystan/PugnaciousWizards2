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
		private var excludeOccupiedTiles:Boolean;
		private var isOk:Boolean = true;
		private var validateTarget:Function;
		
		public function TargetScreen(player:Creature, callback:Function, excludeOccupiedTiles:Boolean, okFunction:Function = null) 
		{
			this.tx = player.position.x;
			this.ty = player.position.y;
			this.player = player;
			this.callback = callback;
			this.excludeOccupiedTiles = excludeOccupiedTiles;
			this.validateTarget = okFunction == null ? checkTarget : okFunction;
			
			bind('up', function():void { moveBy(0, -1); } );
			bind('down', function():void { moveBy(0, 1); } );
			bind('left', function():void { moveBy(-1, 0); } );
			bind('right', function():void { moveBy(1, 0); } );
			bind('up left', function():void { moveBy(-1, -1); } );
			bind('up right', function():void { moveBy(1, -1); } );
			bind('down left', function():void { moveBy(-1, 1); } );
			bind('down right', function():void { moveBy(1, 1); } );
			
			bind('escape', function():void { exit(); } );
			bind('enter', function():void { if (isOk) { exit(); callback(player, tx, ty); } } );
			bind('draw', draw);
			
			isOk = validateTarget(tx, ty);
		}
		
		private function moveBy(mx:int, my:int):void 
		{
			if (tx + mx < 0 || tx + mx > 79 || ty + my < 0 || ty + my > 79)
				return;
				
			tx += mx;
			ty += my;
			
			isOk = validateTarget(tx, ty);
		}
		
		private function checkTarget(x:int, y:int):Boolean
		{
			return player.canSee(x, y) 
				&& !player.world.getTile(x, y).blocksMovement
				&& (!excludeOccupiedTiles || player.world.getCreature(x, y) == null);
		}
		
		public function draw(terminal:AsciiPanel):void 
		{
			terminal.write("Which location?", 2, 78, 0xffffff);
			terminal.write("X", tx, ty, 0xffffff, isOk ? 0x000000 : 0xff3333);
		}
	}
}