// https://gist.github.com/4704144
package knave
{
    import flash.geom.Point;
	
	public class Line 
	{
		public var points:Array = [];

		public function Line(x0:int, y0:int, x1:int, y1:int) {
			calculate(x0, y0, x1, y1);
		}

		protected function calculate(x0:int, y0:int, x1:int, y1:int):void {
			var dx:int = Math.abs(x1 - x0);
			var dy:int = Math.abs(y1 - y0);
			var sx:int = x0 < x1 ? 1 : -1;
			var sy:int = y0 < y1 ? 1 : -1;
			var err:int = dx - dy;
			
			while (true){
				points.push(new Point(x0, y0));
			 
				if (x0==x1 && y0==y1)
					break;
			 
				var e2:int = err * 2;
				if (e2 > -dx) {
					err -= dy;
					x0 += sx;
				}
				if (e2 < dx){
					err += dx;
					y0 += sy;
				}
			}
		}
		
		public static function betweenPoints(p0:Point, p1:Point):Line {
			return new Line(p0.x, p0.y, p1.x, p1.y);
		}
		
		public static function betweenCoordinates(x0:int, y0:int, x1:int, y1:int):Line {
			return new Line(x0, y0, x1, y1);
		}
	}
}