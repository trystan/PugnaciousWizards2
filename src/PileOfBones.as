package  
{
	import flash.geom.Point;
	import spells.Spell;
	
	public class PileOfBones implements Item
	{
		private var origin:Creature;
		public var countdown:int;
		private var world:World;
		
		public function get name():String { return "pile of bones"; }
		
		public function get description():String { return "A pile of bones. Was once a " + origin.type + "."; }
		
		public function PileOfBones(origin:Creature) 
		{
			this.origin = origin;
			this.world = origin.world;
			this.countdown = CurrentGameVariables.skeletonRecoveryTime;
		}
		
		public function canBePickedUpBy(creature:Creature):Boolean { return false; }
		
		public function getPickedUpBy(creature:Creature):void
		{
		}
		
		public function update():void
		{
			if (countdown-- < 1)
			{
				var pos:Point = world.removeItem(this);
				
				if (world.getCreature(pos.x, pos.y) == null)
					world.addCreature(new Skeleton(origin));
				else
					world.addItem(pos.x, pos.y, this);
			}
		}
	}
}