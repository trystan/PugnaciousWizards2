package features
{
	import animations.Arrow;
	import payloads.Fire;
	import payloads.Ice;
	import payloads.Payload;
	import payloads.PayloadFactory;
	import payloads.Poison;
	
	public class TowerTrap extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var payload:Payload;
		
		public function TowerTrap(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.payload = PayloadFactory.random();
			
			while (payload is Ice)
				payload = PayloadFactory.random();
			
			addTile();
		}
		
		override public function retheme(payload:Payload):void
		{
			if (payload is Ice)
				return;
				
			this.payload = payload;
			
			addTile();
		}
		
		private function addTile():void
		{
			if (payload is Fire)
				world.addTile(x, y, Tile.fire_tower);
			else if (payload is Poison)
				world.addTile(x, y, Tile.poison_tower);
			else
				world.addTile(x, y, Tile.tower);
		}
		
		override public function update():void
		{
			for each (var direction:String in ["N","E","S","W","NE","SE","SW","NW"])
				new Arrow(world, x, y, direction, payload);
		}
	}
}