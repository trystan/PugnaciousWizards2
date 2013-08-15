package spells 
{
	import animations.Explosion;
	import flash.geom.Point;
	import knave.RL;
	import payloads.Fire;
	import screens.TargetScreen;
	
	public class AngryTreeSpell implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Angry tree"; }

		public function get description():String
		{
			return "Give a tree the ability to wander around and smash stuff.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, function (x:int, y:int):Boolean {
				return player.canSee(x, y) 
					&& [Tile.tree, Tile.tree_fire_1, Tile.tree_fire_2, Tile.tree_fire_3].indexOf(player.world.getTile(x, y)) > -1;
			}));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			switch(caster.world.getTile(x, y))
			{
				case Tile.tree:
					caster.world.addTile(x, y, Tile.grass);
					caster.world.addCreature(new AngryTree(new Point(x, y)));
					break;
				case Tile.tree_fire_1:
				case Tile.tree_fire_2:
				case Tile.tree_fire_3:
					caster.world.addTile(x, y, Tile.grass_fire);
					
					var c:MovingTree = new AngryTree(new Point(x, y));
					c.burn(100);
					caster.world.addCreature(c);
					break;
			}
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{
			if (Math.random() < 0.95)
				return new SpellCastAction(0, function():void { } );
				
			var candidates:Array = [];
			ai.foreachVisibleLocation(function (x:int, y:int):void
			{
				if (ai.world.getTile(x, y) == Tile.tree)
					candidates.push(new Point(x, y));
			});
			
			if (candidates.length == 0)
				return new SpellCastAction(0, function():void { } );

			var target:Point = candidates[(int)(Math.random() * candidates.length)];
			return new SpellCastAction(0.9, function():void {
					cast(ai, target.x, target.y);
				} );
		}
	}
}