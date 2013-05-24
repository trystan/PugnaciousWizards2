package  
{
	import flash.events.KeyboardEvent;
	
	public interface Screen 
	{
		function handleInput(keyEvent:KeyboardEvent):void
		function refresh():void;
		
		function handleAnimation(animation:Arrow):void;
	}
}