package features 
{
	import payloads.Fire;
	import payloads.Payload;
	public class TimedMeteorEffect extends BaseTimedEffect
	{
		public function TimedMeteorEffect(world:World, x:int, y:int) 
		{
			super(world, x, y);
		}
		
		override public function timeout():void
		{
			var r:int = 9;
			var fire:Payload = new Fire();
			
			for (var xo:int = -(r+1); xo <= r+1; xo++)
			for (var yo:int = -(r+1); yo <= r+1; yo++)
			{
				var dist:int = Math.sqrt(xo * xo + yo * yo);
				if (dist > r)
					continue;
					
				var x2:int = x + xo;
				var y2:int = y + yo;
				var chance:Number = 1.5 - (1.0 * dist / r);
				
				if (Math.random() < 0.5)
					fire.hitTile(world, x2, y2);
					
				if (Math.random() < chance)
				{
					world.addTile(x2, y2, Tile.burnt_ground);
					world.removeFeatureAt(x2, y2);
				}
				
				var c:Creature = world.getCreature(x2, y2);
				if (c != null)
				{
					fire.hitCreature(c);
					c.hurt((r - dist) * 5, "Struck by a falling meteor.");
				}
				
				var items:Array = world.getItems(x, y);
				for each (var i:Item in items)
				{
					if (!(i is EndPiece))
						world.removeItem(i);
				}
			}
		}
	}
}