package  
{
	import flash.geom.Point;
	public class Tests 
	{
		public var passed:Boolean = true;
		public function get failed():Boolean { return !passed; }
		
		public var message:String = "ok";
		
		public function run():void
		{
			movement();
		}
		
		public var position:Point;
			
		private function movement():void 
		{
			position = new Point(5, 5);
			
			moveBy(1, 0);
			assertEqual(position.x, 6);
			assertEqual(position.y, 5);
			
			moveBy(-1, 0);
			assertEqual(position.x, 5);
			assertEqual(position.y, 5);
			
			moveBy(0, 1);
			assertEqual(position.x, 5);
			assertEqual(position.y, 6);
			
			moveBy(0, -1);
			assertEqual(position.x, 5);
			assertEqual(position.y, 5);
		}
		
		private function moveBy(x:Number, y:Number):void 
		{
			position.x += x;
			position.y += y;
		}
		
		private function assertEqual(actual:Object, expected:Object):void
		{
			if (expected == actual)
				return;
			
			message = "Expected " + expected + " but got " + actual + ".";
			trace(message);
			passed = false;
		}
	}
}