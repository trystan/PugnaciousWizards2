package spells 
{
	import animations.Flash;
	
	public class BlindingBlink implements Spell 
	{
		public function get name():String { return "Blinding Blink"; }
		
		public function get description():String { return "You and everyone you see swaps positions and is blinded for a few turns. You are blinded for only half as long."; }
		
		public function playerCast(player:Creature, callback:Function):void 
		{
			cast(player, 0, 0);
			callback();
		}
		
		public function cast(caster:Creature, x:int, y:int):void 
		{
			var all:Array = getVisibleCreatures(caster);
				
			var copy:Array = all.slice();
			var shuffledCreatures:Array = [];
			var shuffledPositions:Array = [];
			
			do
			{
				all = copy.slice();
				shuffledCreatures = [];
				shuffledPositions = [];
			
				while (all.length > 0)
				{
					var index:int = Math.random() * all.length;
					shuffledCreatures.push(all[index]);
					all.splice(index, 1);
				}
				
				for each (var creature:Creature in shuffledCreatures)
					shuffledPositions.push(creature.position.clone());
					
				shuffledPositions.push(shuffledPositions.shift());
				
				var samePosition:Boolean = false;
				for (var i:int = 0; i < shuffledCreatures.length; i++)
				{ 
					if (shuffledPositions[i].x == shuffledCreatures[i].position.x 
							&& shuffledPositions[i].y == shuffledCreatures[i].position.y)
						samePosition = true;
				}
			}
			while (samePosition && shuffledCreatures.length > 1)
			
			applyEffect(caster, shuffledCreatures, shuffledPositions);
		}
		
		private function getVisibleCreatures(caster:Creature):Array 
		{
			var all:Array = [];
			var r:int = caster.visionRadius + 1;
			for (var x:int = -r; x <= r; x++)
			for (var y:int = -r; y <= r; y++)
			{
				if (!caster.canSee(x + caster.position.x, y + caster.position.y))
					continue;
					
				var other:Creature = caster.world.getCreature(x + caster.position.x, y + caster.position.y);
				if (other == null)
					continue;
				
				all.push(other);
			}
			return all;
		}
		
		private function applyEffect(caster:Creature, shuffledCreatures:Array, shuffledPositions:Array):void 
		{
			for (var i:int = 0; i < shuffledCreatures.length; i++)
			{
				shuffledCreatures[i].blind(shuffledCreatures[i] == caster ? 3 : 6);
				shuffledCreatures[i].position.x = shuffledPositions[i].x;
				shuffledCreatures[i].position.y = shuffledPositions[i].y;
			}
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction 
		{
			var doIt:Boolean = Math.random() < 0.1 && getVisibleCreatures(ai).length > 1;
			
			return new SpellCastAction(doIt ? 0.5 : 0, function():void {
				cast(ai, 0, 0);
			});
		}
	}
}