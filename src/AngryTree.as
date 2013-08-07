package  
{
	import flash.geom.Point;
	import knave.Dijkstra;
	
	public class AngryTree extends Creature
	{
		public var path:Array = [];
		
		public function AngryTree(position:Point)
		{
			super(position, "Tree",
				"A really angry tree that wanders around smashing walls and stuff.");
			
			maxHealth = 5 * 6;
			_health = maxHealth;
		}
		
		public override function doAi():void
		{
			wanderLikeATree();
		}
		
		override public function die():void 
		{
		}
		
		override public function bleed(amount:int):void 
		{
		}
		
		override public function isEnemy(other:Creature):Boolean
		{
			return !(other is AngryTree);
		}
		
		public function wanderLikeATree():void 
		{
			var nx:int = Math.random() < 0.50 ? movedBy.x : ((int)(Math.random() * 3) - 1);
			var ny:int = Math.random() < 0.50 ? movedBy.y : ((int)(Math.random() * 3) - 1);
			
			var tile:Tile = world.getTile(position.x + nx, position.y + ny);
			if (tile != Tile.tree && tile.blocksMovement)
				world.addTile(position.x + nx, position.y + ny, Tile.dirt);
			else
				moveBy(nx, ny);
		}
	}
}