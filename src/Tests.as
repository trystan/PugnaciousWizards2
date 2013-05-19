package  
{
	public class Tests 
	{
		public var passed:Boolean = true;
		public function get failed():Boolean { return !passed; }
		
		public var message:String = "ok";
		
		public function run():void
		{
			assertEqual(5, 5);
		}
		
		private function assertEqual(expected:Object, actual:Object):void
		{
			if (expected == actual)
				return;
			
			message = "Expected " + expected + " but got " + actual + ".";
			trace(message);
			passed = false;
		}
	}
}