package  
{
	public class TestFramework 
	{
		public var passed:Boolean = true;
		public function get failed():Boolean { return !passed; }
		
		public var message:String = "ok";
		
		protected function assertEqual(actual:Object, expected:Object):void
		{
			if (expected == actual)
				return;
			
			message = "Expected " + expected + " but got " + actual + ".";
			trace(message);
			passed = false;
		}
		
		protected function assertNotNull(actual:Object):void
		{
			if (actual != null)
				return;
			
			assertEqual("null", "not null");
		}
	}
}