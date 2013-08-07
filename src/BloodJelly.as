package  
{
	import flash.geom.Point;
	import knave.Dijkstra;
	
	public class BloodJelly extends Creature
	{
		public var path:Array = [];
		public var summoner:Creature;
		
		public function BloodJelly(position:Point, summoner:Creature, blood:int)
		{
			super(position, "Blood jelly",
				"This blood has been magically animated into jelly form. It splits when hurt.");
			
			this.summoner = summoner;
				
			maxHealth = blood;
			_health = maxHealth;
			
			meleeDamage = 1;
		}
		
		override public function isEnemy(other:Creature):Boolean 
		{
			return other != null && other != summoner && other.type != this.type;
		}
		
		override public function hurt(amount:int, causeOfDeath:String):void 
		{
			super.hurt(amount, causeOfDeath);
			
			if (health > 1)
			{
				var neighbors:Array = [[ -1, -1], [ -1, 0], [ -1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]];
				
				while (neighbors.length > 0)
				{
					var i:int = (int)(Math.random() * neighbors.length);
					var n:Array = neighbors.splice(i, 1)[0];
					
					if (world.getTile(position.x + n[0], position.y + n[1]).blocksMovement)
						continue;
						
					if (world.getCreature(position.x + n[0], position.y + n[1]) != null)
						continue;
						
					world.addCreature(new BloodJelly(new Point(position.x + n[0], position.y + n[1]), summoner, health / 2));
					_health /= 2;
					break;
				}
			}
		}
		
		override public function die():void
		{
		}
		
		override public function bleed(amount:int):void 
		{
			// super.bleed(amount);
		}
		
		override public function swapsPositionWith(other:Creature):Boolean 
		{
			return other == summoner;
		}
		
		public override function doAi():void
		{
			pathToNextTarget();
			
			if (path.length > 0)
				moveToTarget();
			else
				wanderRandomly();
		}
		
		private function pathToNextTarget():void
		{
			if (canSeeCreature(world.player))
				path = Dijkstra.pathTo(position, 
									function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement },
									function (x:int, y:int):Boolean { return canSee(x, y) && isEnemy(world.getCreature(x, y)); });
		}
		
		private function moveToTarget():void 
		{
			var next:Point = path.shift();
			
			moveBy(clamp(next.x - position.x), clamp(next.y - position.y));
			
			if (Math.abs(next.x - position.x) + Math.abs(next.y - position.y) > 0)
				pathToNextTarget();
			
			if (path.length == 1 && world.isOpenedDoor(path[0].x, path[0].y))
				path.shift();
		}
		
		private function clamp(n:int):int
		{
			return Math.max( -1, Math.min(n, 1));
		}
	}
}