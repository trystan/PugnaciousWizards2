package  
{
	import flash.utils.Dictionary;
	import screens.HelpPopupScreen;
	import knave.RL;
	
	public class HelpSystem 
	{
		public static var showHelpPopups:Boolean = true;
		
		private static var known:Dictionary = new Dictionary();
		
		public static function popup(topic:String, title:String, text:String):void
		{
			if (!showHelpPopups)
				return;
				
			if (known[topic] != null)
				return;
				
			known[topic] = true;
			
			RL.current.enter(new HelpPopupScreen(title + "\n\n" + text));
		}
	}
}