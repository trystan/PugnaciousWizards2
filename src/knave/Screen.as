package knave 
{
	public interface Screen
	{
		function bind(message:String, messageOrHandler:Object, ... handlerArguments:Array):void;
		function trigger(message:String, args:Array=null):void;
	}
}