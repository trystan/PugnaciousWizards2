package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.StaticText;
	import flash.text.TextField;
	
	public class Main extends Sprite 
	{
		public function Main():void 
		{
			if (!runTests())
				return;
				
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function runTests():Boolean
		{
			var tests:Tests = new Tests();
			tests.run();
			if (tests.failed)
			{
				var text:TextField = new TextField();
				text.text = tests.message;
				text.width = text.textWidth + 5;
				addChild(text);
			}
			return tests.passed;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
}