package screens
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.events.KeyboardEvent;
	
	public interface Screen 
	{
		function handleInput(keyEvent:KeyboardEvent):void
		function refresh(terminal:AsciiPanel):void;
		
		function animateOneFrame(terminal:AsciiPanel):Boolean;
	}
}