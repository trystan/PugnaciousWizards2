package  
{
	public interface Item 
	{
		function get name():String;
		function get description():String;
		function getPickedUpBy(creature:Creature):void;
		function canBePickedUp():Boolean;
		function update():void;
	}	
}