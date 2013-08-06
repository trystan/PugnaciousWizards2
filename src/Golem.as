package  
{
	import features.BurningFire;
	import flash.geom.Point;
	import knave.AStar;
	import knave.Dijkstra;
	import payloads.Fire;
	import payloads.Ice;
	
	public class Golem extends Creature
	{
		public var path:Array = [];
		private var summoner:Creature;
		
		public var isImmuneToFire:Boolean = false;
		public var isImmuneToIce:Boolean = false;
		public var isImmuneToPoison:Boolean = false;
		public var isImmuneToBleeding:Boolean = false;
		public var isImmuneToBlinding:Boolean = false;
		
		public function Golem(position:Point, summoner:Creature)
		{
			super(position, "golem",
				"A magically animated creature. Summoned by " + summoner.type + ".");
			
			this.summoner = summoner;
			this.isGoodGuy = true;
		}
		
		override public function burn(amount:int):void 
		{
			if (!isImmuneToFire)
				super.burn(amount);
		}
		
		override public function bleed(amount:int):void 
		{
			if (!isImmuneToBleeding)
				super.bleed(amount);
		}
		
		override public function freeze(amount:int):void 
		{
			if (!isImmuneToIce)
				super.freeze(amount);
		}
		
		override public function poison(amount:int):void 
		{
			if (!isImmuneToPoison)
				super.poison(amount);
		}
		
		override public function blind(amount:int):void 
		{
			if (!isImmuneToBlinding)
				super.blind(amount);
		}
		
		override public function die():void 
		{
			// super.die();
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
		}
		
		public override function doAi():void
		{
			pathToNextTarget();
			
			if (Math.abs(position.x - summoner.position.x) + Math.abs(position.y - summoner.position.y) > 5)
				pathToSummoner();
			
			if (path.length > 0)
				moveToTarget();
			else
				wanderRandomly();
		}
		
		private function pathToSummoner():void
		{
			path = AStar.pathTo(
							function(x:int, y:int):Boolean { return !world.getTile(x, y, true).blocksMovement || world.isClosedDoor(x, y); },
							position,
							summoner.position, true);
		}
		
		private function pathToNextTarget():void
		{
			if (canSeeCreature(world.player))
				path = Dijkstra.pathTo(position, 
							function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement && (summoner.canSee(x, y) || canSee(x, y)) },
							function (x:int, y:int):Boolean { return isEnemy(world.getCreature(x, y)); });
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