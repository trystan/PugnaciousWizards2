package knave
{
	import flash.utils.Dictionary;
	
	public class Bindings
	{
		private var messageQueue:Array = [];
		private var isProcessingMessages:Boolean = false;
		private var bindings:Dictionary = new Dictionary();
		
		public function bind(message:String, messageOrHandler:Object):void
		{
			if (bindings[message] == null)
				bindings[message] = [];
			
			bindings[message].push(messageOrHandler);
		}
		
		public function trigger(message:String, args:Array):void
		{
			if (bindings[message] == null)
				return;
					
			messageQueue.push( { message:message, args:args } );
			handleMessages();
		}
		
		private function handleMessages():void
		{
			if (isProcessingMessages)
				return;
			
			isProcessingMessages = true;
			while (messageQueue.length > 0)
			{
				var item:Object = messageQueue.shift();
				var message:String = item.message;
				var args:Array = item.args;
				
				for each (var thing:Object in bindings[message])
				{
					if (thing is String)
						trigger(thing as String, args);
					else if (thing is Function)
						callFunc(thing as Function, args);
				}
			}
			isProcessingMessages = false;
		}
		
		private function callFunc(func:Function, args:Array):void
		{
			if (args == null)
				args = [];
				
			switch (args.length)
			{
				case 0: func(); break;
				case 1: func(args[0]); break;
				case 2: func(args[0], args[1]); break;
				case 3: func(args[0], args[1], args[2]); break;
				case 4: func(args[0], args[1], args[2], args[3]); break;
				case 5: func(args[0], args[1], args[2], args[3], args[4]); break;
				default: throw new Error("Knave can only handle binding to functions with 5 or fewer parameters.");
			}
		}
	}
}