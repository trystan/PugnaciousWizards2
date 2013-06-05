package knave 
{
	import com.headchant.asciipanel.AsciiPanel;
	public interface Screen
	{
		function bind(message:String, messageOrHandler:Object):void;
		function trigger(message:String, args:Array=null):void;
		
		function draw(terminal:AsciiPanel):void;
	}
}