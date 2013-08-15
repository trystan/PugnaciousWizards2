package knave 
{
	public class Text 
	{
		public static function wordWrap(width:int, text:String):Array
		{
			var lines:Array = [];
			for each (var line:String in text.split("\n"))
			{
				if (line.length == 0)
					lines.push("");
				
				while (line.length > width)
				{
					var i:int = line.substr(0, width).lastIndexOf(" ");
					lines.push(line.substr(0, i));
					line = line.substr(i + 1);
				}
				while (line.length > 0 && line.charAt(0) == " ")
					line = line.substr(1);
					
				if (line.length > 0)
					lines.push(line);
			}
			return lines;
		}
		
		public static function padToCenter(width:int, line:String):String
		{
			var left:int = (width - line.length) / 2;
			var right:int = width - line.length;
			
			var i:int = 0;
			for (i = 0; i < left; i++)
				line = " " + line;
			for (i = 0; i < right; i++)
				line = line + " ";
				
			if (line.length >= width)
				line = line.substr(0, width);
				
			return line;
		}
	}

}