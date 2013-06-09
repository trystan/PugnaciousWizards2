package knave 
{
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Color 
	{
		private var r:int;
		private var g:int;
		private var b:int;
		
		public function Color(r:int, g:int, b:int)
		{
			this.r = r;
			this.g = g;
			this.b = b;
		}
		
		public static function from(value:*):Color
		{
			if (value is int)
				return integer(value);
			
			if (value is Array)
				return rgb(value[0], value[1], value[2]);
			
			if (!isNaN(value.h) && !isNaN(value.s) && !isNaN(value.v))
				return hsv(value.h, value.s, value.v);
			
			if (!isNaN(value.r) && !isNaN(value.g) && !isNaN(value.b))
				return hsv(value.r, value.g, value.b);
				
			return rgb(255, 0, 0);
		}
		
		public static function hsv(h:Number, s:Number, v:Number):Color
		{
			 var r:Number, g:Number, b:Number, i:Number, f:Number, p:Number, q:Number, t:Number;
			 h %= 360;
			 if (v == 0) 
				return new Color(0, 0, 0);
				
			 s /= 100;
			 v /= 100;
			 h /= 60;
			 i = Math.floor(h);
			 f = h - i;
			 p = v * (1 - s);
			 q = v * (1 - (s * f));
			 t = v * (1 - (s * (1 - f)));
			 
			 switch (i)
			 {
				 case 0: r = v; g = t; b = p; break;
				 case 1: r = q; g = v; b = p; break;
				 case 2: r = p; g = v; b = t; break;
				 case 3: r = p; g = q; b = v; break;
				 case 4: r = t; g = p; b = v; break;
				 case 5: r = v; g = p; b = q; break;
			 }
			 
			 return new Color(Math.floor(r*255), Math.floor(g*255), Math.floor(b*255));
		}
		
		public static function rgb(r:int, g:int, b:int):Color
		{
			return new Color(r, g, b);
		}
		
		public static function integer(color:uint):Color
		{
			var r:int = (color >> 16) & 0xff;
			var g:int = (color >>  8) & 0xff;
			var b:int = (color      ) & 0xff;
			
			return new Color(r, g, b);
		}
		
		
		public function toInt():uint
		{
			return (255 << 24) | (r << 16) | (g << 8) | b;
		}
		
		public function lerp(other:Color, percent:Number):Color
		{
			var key:String = toInt() + "," + other.toInt() + "," + percent;
			var value:Color = lerp_cache[key];
			
			if (value == null)
			{
				value = lerp_real(other, percent);
				lerp_cache[key] = value;
			}
			
			return value;
		}
		
		private static var lerp_cache:Dictionary = new Dictionary();
		private function lerp_real(other:Color, percent:Number):Color
		{
			var r2:int = other.r;
			var g2:int = other.g;
			var b2:int = other.b;
			
			var inverse:Number = 1 - percent;
			
			return rgb(r * percent + r2 * inverse, g * percent + g2 * inverse, b * percent + b2 * inverse);
		}
	}
}