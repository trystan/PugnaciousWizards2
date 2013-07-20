package spells 
{
	import flash.geom.Point;
	import knave.RL;
	import screens.TargetScreen;
	
	public class SummonElemental implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Summon elemental"; }
		
		public function get description():String
		{
			return "Lose a bit of your own life to summon a being of pure fire, water, ice, stone, or other things....";
		}
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetScreen(player, cast, false, function (x:int, y:int):Boolean { return true; }));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			caster.maxHealth -= 5;
			if (caster.health > caster.maxHealth)
				caster.hurt(caster.health - caster.maxHealth, "You shared your life with too many summed others.");
				
			var creature:Creature = caster.world.getCreature(x, y);
			
			if (creature != null)
			{
				creature.hurt(15, "You were seriously meesd up by a summing portal.");
			}
			else
			{
				var t:Tile = caster.world.getTile(x, y);
				
				switch (t)
				{
					case Tile.wall:
					case Tile.moving_wall:
						caster.world.addCreature(new SummonedCreature(new Point(x, y), caster, "stone"));
						break;
					case Tile.grass_fire:
					case Tile.tree_fire_1:
					case Tile.tree_fire_2:
					case Tile.tree_fire_3:
					case Tile.door_closed_fire:
					case Tile.door_opened_fire:
						caster.world.addCreature(new SummonedCreature(new Point(x, y), caster, "fire"));
						break;
					case Tile.shallow_water:
						caster.world.addCreature(new SummonedCreature(new Point(x, y), caster, "water"));
						break;
					case Tile.frozen_water:
						caster.world.addCreature(new SummonedCreature(new Point(x, y), caster, "ice"));
						break;
					default:
						caster.world.addCreature(new SummonedCreature(new Point(x, y), caster, "air"));
						break
				}
			}
			
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction
		{
			return new SpellCastAction(ai.maxHealth > 25 ? 0.01 : 0, function():void
			{
				var x:int = -1;
				var y:int = -1;
				var tries:int = 0;
				
				while (!ai.canSee(x, y) && tries++ < 100)
				{
					x = ai.position.x + (Math.random() * ai.visionRadius * 2) - ai.visionRadius; 
					y = ai.position.y + (Math.random() * ai.visionRadius * 2) - ai.visionRadius;
				}
				
				if (ai.canSee(x, y))
					cast(ai, x, y);
			});
		}
	}
}