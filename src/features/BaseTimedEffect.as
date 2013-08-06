package features 
{
	public class BaseTimedEffect extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var timer:int = 6;
		
		public function BaseTimedEffect(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
		}
		
		override public function contains(x:int, y:int):Boolean
		{
			return this.x == x && this.y == y;
		}
		
		override public function update():void
		{
			if (timer-- < 1)
			{
				timeout();
				world.removeFeature(this);
			}
		}
		
		public function timeout():void
		{
			
		}
	}
}