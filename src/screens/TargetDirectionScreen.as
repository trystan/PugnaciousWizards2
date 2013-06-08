package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import knave.BaseScreen;
	
	public class TargetDirectionScreen extends BaseScreen
	{
		private var callback:Function;
		
		public function TargetDirectionScreen(player:Creature, callback:Function) 
		{
			this.callback = callback;
			
			bind('left', function():void { callback(player, -1, 0); exit(); } );
			bind('right', function():void { callback(player, 1, 0); exit(); } );
			bind('up', function():void { callback(player, 0, -1); exit(); } );
			bind('down', function():void { callback(player, 0, 1); exit(); } );
			bind('up left', function():void { callback(player, -1, -1); exit(); } );
			bind('up right', function():void { callback(player, 1, -1); exit(); } );
			bind('down left', function():void { callback(player, -1, 1); exit(); } );
			bind('down right', function():void { callback(player, 1, 1); exit(); } );
			bind('escape', function():void { exit(); } );
			bind('draw', draw);
		}
		
		public function draw(terminal:AsciiPanel):void 
		{
			terminal.write("Which direction?", 2, 78, 0xffffff);
		}
	}
}