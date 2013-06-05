package knave 
{
	public interface Screen
	{
		function bind(message:String, messageOrHandler:Object):void;
		function trigger(message:String, args:Array=null):void;
	}
}