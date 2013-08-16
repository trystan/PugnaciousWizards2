package spells 
{
	import animations.Explosion;
	import flash.geom.Point;
	import knave.RL;
	import payloads.Fire;
	import payloads.Healing;
	import screens.TargetScreen;
	
	public class AlterReality implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Alter reality"; }
		
		public function get description():String
		{
			return "Alter the very fabric of space. No way of knowing what can happen.";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, function(x:int, y:int):Boolean { 
				return player.canSee(x, y);
			}));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			var tiles:Array = [
				Tile.portal, Tile.magma, Tile.shallow_water,
				Tile.wall, Tile.wall,
				Tile.floor_dark, Tile.floor_light, Tile.floor_dark, Tile.floor_light, 
				Tile.mystic_floor_dark, Tile.mystic_floor_light, Tile.mystic_floor_dark, Tile.mystic_floor_light, 
				Tile.dirt, Tile.dirt, Tile.dirt, Tile.dirt, Tile.dirt, Tile.dirt,
				Tile.dirt, Tile.dirt, Tile.dirt, Tile.dirt, Tile.dirt, Tile.dirt, 
			];
			
			var r:int = 6;
			for (var ox:int = -r; ox < r; ox++)
			for (var oy:int = -r; oy < r; oy++)
			{
				if (ox * ox + oy * oy > r * r)
					continue;
				
				caster.world.removeItemsAt(x + ox, y + oy);
				
				caster.world.removeFeatureAt(x + ox, y + oy);
				
				if (Math.random() < 5)
					caster.world.addTile(x + ox, y + oy, tiles[(int)(Math.random() * tiles.length)]);
				
				var c:Creature = caster.world.getCreature(x + ox, y + oy);
				
				if (c != null)
				{
					if (Math.random() < 0.5)
						c.heal(1 + Math.random() * 20);
					else
						c.hurt(1 + Math.random() * 50, "Ripped apart by altered reality.");
						
					caster.world.getTile(x + ox, y + oy).apply(c);
				}
			}
			
			if (Math.random() < 0.10)
				caster.world.addCreature(new Imp(new Point(x, y)));
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction
		{
			return new SpellCastAction(0.01, function():void
			{
				var x:int = -1;
				var y:int = -1;
				var tries:int = 0;
				
				while (!ai.canSee(x, y) && tries++ < 100)
				{
					x = ai.position.x + (Math.random() * 3) - 1; 
					y = ai.position.y + (Math.random() * 3) - 1;
				}
				
				if (ai.canSee(x, y))
				{
					cast(ai, x, y);
				}
			});
		}
	}
}