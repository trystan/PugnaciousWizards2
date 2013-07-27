package spells 
{
	import animations.Explosion;
	import flash.geom.Point;
	import knave.RL;
	import payloads.Fire;
	import screens.TargetScreen;
	
	public class TreeAlly implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Tree's revenge"; }
		
		public function get description():String
		{
			return "Give a tree the ability to walk and smash.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, false, function (x:int, y:int):Boolean {
				return [Tile.tree, Tile.tree_fire_1, Tile.tree_fire_2, Tile.tree_fire_3].indexOf(player.world.getTile(x, y)) > -1;
			}));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			switch(caster.world.getTile(x, y))
			{
				case Tile.tree:
					caster.world.addTile(x, y, Tile.grass);
					caster.world.addCreature(new MovingTree(new Point(x, y)));
					break;
				case Tile.tree_fire_1:
				case Tile.tree_fire_2:
				case Tile.tree_fire_3:
					caster.world.addTile(x, y, Tile.grass_fire);
					
					var c:MovingTree = new MovingTree(new Point(x, y));
					c.burn(100);
					caster.world.addCreature(c);
					break;
			}
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{
			for (var ox:int = -ai.visionRadius; ox < ai.visionRadius; ox++)
			for (var oy:int = -ai.visionRadius; oy < ai.visionRadius; oy++)
			{
				var x:int = ai.position.x + ox;
				var y:int = ai.position.y + oy;
				
				if (ai.world.getTile(x, y) != Tile.tree)
					continue;
				
				if (Math.random() < 0.01)
					return new SpellCastAction(10, function():void
					{
						cast(ai, x + 2, y);
					});
			}
			
			return new SpellCastAction(0, function():void
			{
				cast(ai, ai.position.x, ai.position.y);
			});
		}
	}
}