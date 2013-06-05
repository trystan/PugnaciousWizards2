package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import knave.BaseScreen;
	
	public class TargetDirectionScreen extends BaseScreen
	{
		private var callback:Function;
		
		public function TargetDirectionScreen( callback:Function) 
		{
			this.callback = callback;
			
			bind('left', function():void { callback(-1, 0); exit(); } );
			bind('right', function():void { callback(1, 0); exit(); } );
			bind('up', function():void { callback(0, -1); exit(); } );
			bind('down', function():void { callback(0, 1); exit(); } );
			bind('escape', function():void { exit(); } );
		}
		
		public override function draw(terminal:AsciiPanel):void 
		{
			terminal.write("Which direction?", 2, 78, 0xffffff);
			terminal.paint();
		}
	}
}