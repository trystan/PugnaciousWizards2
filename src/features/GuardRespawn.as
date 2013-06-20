package features 
{
	import flash.geom.Point;
	
	public class GuardRespawn extends CastleFeature
	{
		public var world:World;
		public var room:Room;
		
		public function GuardRespawn(room:Room, world:World) 
		{
			this.world = world;
			this.room = room;
		}
		
		public override function update():void
		{
			if (Math.random() > 0.025)
				return;
			
			var guardCount:int = 0;
			
			for (var ox:int = 0; ox < 7; ox++)
			for (var oy:int = 0; oy < 7; oy++)
			{
				var x:int = room.worldPosition.x + ox;
				var y:int = room.worldPosition.y + oy;
				
				var c:Creature = world.getCreature(x, y);
				if (c is Guard)
					guardCount++;
			}
			
			if (guardCount < room.distance / 7 + 1)
			{
				var cx:int = room.worldPosition.x + Math.random() * 7 + 1;
				var cy:int = room.worldPosition.y + Math.random() * 7 + 1;
				
				if (!world.getTile(cx, cy).blocksMovement && world.getCreature(cx, cy) == null)
					world.addCreature(new Guard(new Point(cx, cy)));
			}
		}
	}
}