package features 
{
	import flash.geom.Point;
	public class ArcherRespawn extends CastleFeature
	{
		public var world:World;
		public var room:Room;
		
		public function ArcherRespawn(room:Room, world:World) 
		{
			this.world = world;
			this.room = room;
		}
		
		override public function contains(x:int, y:int):Boolean
		{
			return room.contains(x, y);
		}
		
		public override function update():void
		{
			if (Math.random() > 0.05)
				return;
			
			var archerCount:int = 0;
			
			for (var ox:int = 0; ox < 7; ox++)
			for (var oy:int = 0; oy < 7; oy++)
			{
				var x:int = room.worldPosition.x + ox;
				var y:int = room.worldPosition.y + oy;
				
				var c:Creature = world.getCreature(x, y);
				if (c is Archer)
					archerCount++;
			}
			
			var maxArchers:int = CurrentGameVariables.archerCount * (room.distance / 6) + 1;
			if (archerCount < maxArchers)
			{
				var cx:int = room.worldPosition.x + Math.random() * 7 + 1;
				var cy:int = room.worldPosition.y + Math.random() * 7 + 1;
				
				if (!world.getTile(cx, cy).blocksMovement && world.getCreature(cx, cy) == null)
					world.addCreature(new Archer(new Point(cx, cy)));
			}
		}
	}
}