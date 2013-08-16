package  
{
	import flash.geom.Point;
	import spells.PoisonFog;
	import spells.PullAndFreeze;
	import spells.Spell;
	import spells.SpellCastAction;
	import knave.Dijkstra;
	import spells.SummonGolem;
	import spells.Telekenesis;
	
	public class Hero extends Creature
	{
		private var path:Array = [];
		
		public function Hero(position:Point)
		{
			super(position, "Hero", 
				"It's a brave - or foolish - hero who is attempting to find the pieces of the amulet.");
			
			isGoodGuy = true;
			usesMagic = true;
			
			maxHealth *= 2;
			_health = maxHealth;
		}
		
		public override function doAi():void
		{
			if (canCastMagic)
			{
				for each (var spell:Spell in magic)
				{
					var action:SpellCastAction = spell.aiGetAction(this);
					if (Math.random() < action.percentChance)
					{
						action.callback();
						return;
					}
				}
			}
			
			if (path.length == 0)
				pathToNextTarget();
			
			if (world.getTile(position.x, position.y).isFog || Math.random() < 0.02)
				wanderRandomly();
			else if (path.length > 0)
				moveToTarget();
			else
				wanderRandomly();
		}
		
		private function pathToNextTarget():void 
		{
			if (blindCounter > 0)
			{
				path = [];
			}
			else if (this.hasAllAmulets)
			{
				path = pathBackHome();
			}
			else
			{
				path = pathToNearestItem();
					
				if (path.length == 0)
					path = pathToNearestDoor();
			}
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
		
		private function pathBackHome():Array 
		{
			return Dijkstra.pathTo(
				new Point(position.x, position.y),
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement; },
				function (x:int, y:int):Boolean { return x < 3; } );
		}
		
		private function pathToNearestItem():Array 
		{
			var self:Creature = this;
			return Dijkstra.pathTo(
				new Point(position.x, position.y),
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement; },
				function (x:int, y:int):Boolean { 
						var item:Item = world.getItem(x, y);
						return item != null && item.canBePickedUpBy(self);
					} );
		}
		
		private function pathToNearestDoor():Array 
		{
			return Dijkstra.pathTo(
				new Point(position.x, position.y),
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement; },
				function (x:int, y:int):Boolean { return world.isClosedDoor(x, y); } );
		}
	}
}