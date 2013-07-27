package knave 
{
	public class RLBuilder2
	{
		private var rl:RL;
		
		private var usesNumpad:Boolean = false;
		private var usesKeyboard:Boolean = false;
		private var usesWait:Boolean = false;
		
		public function RLBuilder2(rl:RL)
		{
			this.rl = rl;
		}
		
		public function useAllMovementKeys():RLBuilder2
		{
			return useWASD().useHJKLYUBN().useNumpad();
		}
		
		public function useWASD():RLBuilder2
		{
			rl.bind('a', 'left');
			rl.bind('d', 'right');
			rl.bind('w', 'up');
			rl.bind('s', 'down');
			
			return this;
		}
		
		public function useHJKL():RLBuilder2
		{
			rl.bind('h', 'left');
			rl.bind('j', 'down');
			rl.bind('k', 'up');
			rl.bind('l', 'right');
			
			usesKeyboard = true;
			
			return this;
		}
			
		public function useHJKLYUBN():RLBuilder2
		{
			rl.bind('h', 'left');
			rl.bind('j', 'down');
			rl.bind('k', 'up');
			rl.bind('l', 'right');
			rl.bind('y', 'up left');
			rl.bind('u', 'up right');
			rl.bind('b', 'down left');
			rl.bind('n', 'down right');
			
			usesKeyboard = true;
			
			if (usesWait)
				rl.bind('.', 'wait');
				
			return this;
		}
		
		public function useCardinalNumpad():RLBuilder2
		{
			rl.bind('numpad 2', 'down');
			rl.bind('numpad 4', 'left');
			rl.bind('numpad 6', 'right');
			rl.bind('numpad 8', 'up');
			
			usesNumpad = true;
			
			if (usesWait)
				rl.bind('numpad 5', 'wait');
				
			return this;
		}
		
		public function useNumpad():RLBuilder2
		{
			rl.bind('numpad 1', 'down left');
			rl.bind('numpad 2', 'down');
			rl.bind('numpad 3', 'down right');
			rl.bind('numpad 4', 'left');
			rl.bind('numpad 6', 'right');
			rl.bind('numpad 7', 'up left');
			rl.bind('numpad 8', 'up');
			rl.bind('numpad 9', 'up right');
			
			usesNumpad = true;
			
			if (usesWait)
				rl.bind('numpad 5', 'wait');
				
			return this;
		}
		
		public function useWaitKey():RLBuilder2
		{
			if (usesKeyboard)
				rl.bind('.', 'wait');
			if (usesNumpad)
				rl.bind('5', 'wait');
				
			usesWait = true;
			
			return this;
		}
		
		public function bind(message:String, messageOrHandler:Object):RLBuilder2
		{
			rl.bind(message, messageOrHandler);
			
			return this;
		}
		
		public function build(screen:Screen):RL
		{
			RL.current = rl;
		
			rl.enter(screen);
				
			return rl;
		}
	}
}