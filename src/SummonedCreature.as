package  
{
	import features.BurningFire;
	import flash.geom.Point;
	import knave.Dijkstra;
	import payloads.Fire;
	import payloads.Ice;
	
	public class SummonedCreature extends Creature
	{
		public var path:Array = [];
		public var element:String;
		private var summoner:Creature;
		
		public function SummonedCreature(position:Point, summoner:Creature, element:String)
		{
			super(position, element + " creature",
				"A creature of pure " + element + ". Summoned by " + summoner.type + ".");
			
			this.summoner = summoner;
			this.element = element;
			
			maxHealth = 5 * 5;
			
			switch (element)
			{
				case "stone":
					maxHealth += 5 * 2;
					break;
				case "air":
					maxHealth -= 5 * 1;
			}
			
			_health = maxHealth;
		}
		
		override public function burn(amount:int):void 
		{
			if (element == "fire")
				heal(1);
			else if (element == "water")
				hurt(15, "Boiled.");
			else if (element == "ice")
				element = "water";
			// super.burn(amount);
		}
		
		override public function bleed(amount:int):void 
		{
			// super.bleed(amount);
		}
		
		override public function freeze(amount:int):void 
		{
			if (element == "water")
				element = "ice";
			else if (element == "ice")
				heal(5);
			// super.freeze(amount);
		}
		
		override public function isEnemy(other:Creature):Boolean 
		{
			return other != null && other != this && other != summoner;
		}
		
		override public function swapsPositionWith(other:Creature):Boolean 
		{
			return other == summoner;
		}
		
		override protected function melee(other:Creature):void 
		{
			super.melee(other);
			
			if (element == "fire" && Math.random() < 0.5)
				new Fire().hitCreature(other);
			else if (element == "ice" && Math.random() < 0.5)
				new Ice().hitCreature(other);
		}
		
		public override function doAi():void
		{
			var moves:int = 0;
			
			do
			{
				pathToNextTarget();
				
				if (path.length > 0)
					moveToTarget();
				else
					wanderRandomly();
				
				moves++;
					
				if (element == "fire")
					new Fire().hitTile(world, position.x, position.y);
				else if (element == "ice")
					new Ice().hitTile(world, position.x, position.y);
			} 
			while (moves == 1 && element == "air");
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