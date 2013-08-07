package animations
{
	public interface Animation 
	{
		function get x():int;
		function get y():int;
		function get direction():String;
		function get done():Boolean;
		function update():void;
	}
}