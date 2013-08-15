package animations
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.geom.Point;
	import knave.Line;
	import payloads.Ice;
	import payloads.Payload;
	
	public class PullAndFreezeExpansion implements Animation
	{
		public function get x():int { return _x; }
		public function get y():int { return _y; }
		public function get direction():String { return ""; }
		
		public var _x:int;
		public var _y:int;
		public var world:World;
		public var radius:int;
		
		private var _done:Boolean = false;
		public function get done():Boolean { return _done; }
		
		public function PullAndFreezeExpansion(world:World, x:int, y:int) 
		{
			this.world = world;
			this._x = x;
			this._y = y;
			this.radius = 0;
			
			world.addAnimationEffect(this);
		}
		
		public function update():void
		{
			radius++;
			
			if (radius > 5)
			{
				_done = true;
				return;
			}
			
			var ice:Payload = new Ice();
			
			var affected:Array = [];
			for (var x0:int = x - radius; x0 < x + radius; x0++)
			for (var y0:int = y - radius; y0 < y + radius; y0++)
			{
				ice.hitTile(world, x0, y0);
				var creature:Creature = world.getCreature(x0, y0);
				if (creature != null)
					affected.push(creature);
			}
			
			while (affected.length > 0)
			{
				var i:int = Math.random() * affected.length;
				var target:Creature = affected.splice(i, 1)[0];
				
				ice.hitCreature(target);
				
				var path:Array = new Line(target.position.x, target.position.y, x, y).points;
				path.shift() // skip the starting point
				
				while (path.length > 0)
				{
					var next:Point = path.shift();
					if (world.getCreature(next.x, next.y) != null)
						break;
						
					if (world.getTile(next.x, next.y, true).blocksMovement)
						break;
					
					target.moveTo(next.x, next.y);
				}
			}
		}
	}
}