package  
{
	import flash.geom.Point;
	public class Hero extends Player
	{
		public function Hero(position:Point)
		{
			super(position);
		}
		
		public function update():void
		{
			moveBy((int)(Math.random() * 3) - 1, (int)(Math.random() * 3) - 1);
		}
	}
}