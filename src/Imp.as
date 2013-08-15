package  
{
	import flash.geom.Point;
	import knave.AStar;
	import knave.Color;
	import payloads.Payload;
	import spells.MagicMissile;
	import spells.Spell;
	import spells.SpellCastAction;
	import knave.Dijkstra;
	import spells.Telekenesis;
	
	public class Imp extends Creature
	{
		private var path:Array = [];
		public var aura:Payload;
		
		public function Imp(position:Point)
		{
			super(position, "Imp", 
				"A magical being from another reality. Only powerful magic and bad luck can pull it into our reality.");
			
			maxHealth = 5 * 4;
			_health = maxHealth;
			
			usesMagic = true;
			addMagicSpell(new MagicMissile());
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
			
			var candidates:Array = [wanderRandomly];
			
			if (canSeeCreature(world.player))
				pathToNextTarget();
			
			if (path.length > 0)
				candidates.push(moveToTarget);
				
			var pathTo8Directions:Array = pathIntoEightDirections();
			if (pathTo8Directions.length > 0)
				candidates.push(function():void {
					path = pathTo8Directions;
					moveToTarget();
				});
				
			var pathFrom8Directions:Array = pathOutOfHarmsWay();
			if (pathFrom8Directions.length > 0)
				candidates.push(function():void {
					path = pathFrom8Directions;
					moveToTarget();
				});
				
			candidates[(int)(Math.random() * candidates.length)]();
		}
		
		private function pathIntoEightDirections():Array
		{
			if (canSeeCreature(world.player))
				return Dijkstra.pathTo(position, 
									function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement; },
									function (x:int, y:int):Boolean { 
										return world.player.position.x == x && world.player.position.y == y
											|| isInArcherLine(new Point(x, y), world.player.position); } );
			return [];
		}
		
		private function pathOutOfHarmsWay():Array
		{
			if (canSeeCreature(world.player))
				return Dijkstra.pathTo(position, 
									function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement; },
									function (x:int, y:int):Boolean { 
										return world.player.position.x == x && world.player.position.y == y
											|| !isInArcherLine(new Point(x, y), world.player.position); } );
			return [];
		}
		
		private function isInArcherLine(from:Point, to:Point):Boolean
		{
			return from.x - to.x == 0 
					|| from.y == to.y
					|| Math.abs(from.x - to.x) - Math.abs(from.y - to.y) == 0
		}
		
		private function pathToNextTarget():void 
		{
			if (blindCounter > 0)
			{
				path = [];
			}
			else
			{
				path = pathToVisibleItem();
					
				if (path.length == 0)
					path = pathToNearestGoodGuy();
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
		
		private function pathToVisibleItem():Array 
		{
			var self:Creature = this;
			return Dijkstra.pathTo(
				new Point(position.x, position.y),
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement && self.canSee(x, y) },
				function (x:int, y:int):Boolean { 
						var item:Item = world.getItem(x, y);
						return item != null && item.canBePickedUpBy(self);
					} );
		}
		
		private function pathToNearestGoodGuy():Array 
		{
			return AStar.pathTo(
						function(x:int, y:int):Boolean { return !world.getTile(x, y, true).blocksMovement; },
					    position,
						world.player.position,
						false);
		}
	}
}