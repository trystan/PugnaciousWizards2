package  
{
	import flash.geom.Point;
	import knave.AStar;
	import spells.Spell;
	import spells.SpellCastAction;
	import knave.Dijkstra;
	import spells.Telekenesis;
	
	public class EnemyWizard extends Creature
	{
		private var path:Array = [];
		
		public function EnemyWizard(position:Point)
		{
			super(position, "Wizard", 
				"An enemy wizard who has sworn to protect the pieces of the amulet.");
			
			maxHealth = 5 * 10;
			_health = maxHealth;
			
			usesMagic = true;
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
			
			if (canSeeCreature(world.player))
				pathToNextTarget();
			
			if (path.length > 0)
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
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement && world.getTile(x, y) != Tile.door_closed; },
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