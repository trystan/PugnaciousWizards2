package spells 
{
	import animations.Explosion;
	import knave.RL;
	import payloads.Fire;
	import screens.TargetScreen;
	
	public class FireJump implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Fire jump"; }
		
		public function get description():String
		{
			return "Teleport nearby and create a fiery explosion near you.\n\nMay start a forest fire.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, true));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			if (!caster.canSee(x, y))
				return;
				
			caster.moveTo(x, y);
			new Explosion(caster.world, x, y, new Fire());
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{
			if (Math.random() < 0.8)
				return new SpellCastAction(0, function():void
				{
					cast(ai, ai.position.x, ai.position.y);
				});
			
			for (var ox:int = -ai.visionRadius; ox < ai.visionRadius; ox++)
			for (var oy:int = -ai.visionRadius; oy < ai.visionRadius; oy++)
			{
				var x:int = ai.position.x + ox;
				var y:int = ai.position.y + oy;
				
				if (ai.world.getTile(x, y) != Tile.wood_door_opened || ai.world.getTile(x, y).blocksMovement)
					continue;
				
				if (ai.world.getTile(x - 1, y - 1) == Tile.tree
						&& ai.world.getTile(x - 1, y - 0) == Tile.tree
						&& ai.world.getTile(x - 1, y + 1) == Tile.tree)
					return new SpellCastAction(1, function():void
						{
							cast(ai, x + 2, y);
						});
						
				if (ai.world.getTile(x + 1, y - 1) == Tile.tree
						&& ai.world.getTile(x + 1, y - 0) == Tile.tree
						&& ai.world.getTile(x + 1, y + 1) == Tile.tree)
					return new SpellCastAction(1, function():void
						{
							cast(ai, x - 2, y);
						});
						
				if (ai.world.getTile(x - 1, y - 1) == Tile.tree
						&& ai.world.getTile(x + 0, y - 1) == Tile.tree
						&& ai.world.getTile(x + 1, y - 1) == Tile.tree)
					return new SpellCastAction(1, function():void
						{
							cast(ai, x, y + 2);
						});
						
				if (ai.world.getTile(x - 1, y + 1) == Tile.tree
						&& ai.world.getTile(x + 0, y + 1) == Tile.tree
						&& ai.world.getTile(x + 1, y + 1) == Tile.tree)
					return new SpellCastAction(1, function():void
						{
							cast(ai, x, y - 2);
						});
			}
			
			return new SpellCastAction(0, function():void
			{
				cast(ai, ai.position.x, ai.position.y);
			});
		}
	}
}