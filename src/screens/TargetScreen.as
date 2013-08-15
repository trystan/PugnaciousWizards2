package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import knave.BaseScreen;
	import knave.RL;
	
	public class TargetScreen extends DomainScreen
	{
		private var callback:Function;
		private var tx:int;
		private var ty:int;
		private var player:Creature;
		private var excludeOccupiedTiles:Boolean;
		private var validateTarget:Function;
		private var isOk:Boolean;
		
		public function TargetScreen(player:Creature, callback:Function, okFunction:Function) 
		{
			this.tx = player.position.x;
			this.ty = player.position.y;
			this.player = player;
			this.callback = callback;
			this.validateTarget = okFunction;
			
			bind('up', moveBy, 0, -1);
			bind('down', moveBy, 0, 1);
			bind('left', moveBy, -1, 0);
			bind('right', moveBy, 1, 0);
			bind('up left', moveBy, -1, -1);
			bind('up right', moveBy, 1, -1);
			bind('down left', moveBy, -1, 1);
			bind('down right', moveBy, 1, 1);
			
			bind('escape', function():void { exit(); } );
			bind('click', 'do it');
			bind('enter', 'do it');
			bind('do it', function():void { if (isOk) { exit(); callback(player, tx, ty); } } );
			bind('draw', draw);
			
			bind('mouse', moveTo);
			
			isOk = validateTarget(tx, ty);
		}
		
		private function moveTo(mx:int, my:int, event:Object):void 
		{
			tx = Math.min(mx / 8, 79);
			ty = my / 8;
			
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
		
		public function draw(terminal:AsciiPanel):void 
		{
			terminal.write("Where? (use movement keys or mouse)", 2, 78, 0xffffff);
			
			drawRecticle(terminal, tx, ty, isOk ? 0xffffff : 0xff3333, 0x000000);
		}
	}
}