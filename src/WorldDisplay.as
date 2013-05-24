package  
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class WorldDisplay extends Sprite
	{
		public var player:Player;
		public var world:World;
		private var terminal:AsciiPanel;
		public var perlinBitmap:BitmapData;
		
		private var wood_bg:int = hsv(25, 80, 30);
		private var wood_fg:int = hsv(25, 80, 50);
		private var stone_bg:int = hsv(200, 5, 35);
		private var stone_fg:int = hsv(200, 5, 45);
		private var tile_1:int = hsv(200, 5, 10);
		private var tile_2:int = hsv(200, 5, 12);
		private var tile_3:int = hsv(200, 5, 12);
		private var tile_4:int = hsv(200, 5, 14);
		
		public function WorldDisplay(player:Player, world:World) 
		{
			this.player = player;
			this.world = world;
			
			terminal = new AsciiPanel(100, 80);
			terminal.useRasterFont(AsciiPanel.codePage437_8x8, 8, 8);
			addChild(terminal);
			
			perlinBitmap = new BitmapData(80, 80, false, 0x00CCFFCC);
			var randomNum:Number = Math.floor(Math.random() * 10);
			perlinBitmap.perlinNoise(6, 6, 6, randomNum, false, true, 1, true, null);
		}
		
		public function draw(clear:Boolean = true):void
		{
			terminal.clear();
			
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				terminal.write(tile(x, y), x, y, fg(x, y), bg(x, y));
				
			for each (var placedItem:Object in world.items)
				terminal.write(item_glyph(placedItem.item), placedItem.x, placedItem.y, item_color(placedItem.item), bg(placedItem.x, placedItem.y));
				
			terminal.write("@", player.position.x, player.position.y, 0xffffff, bg(player.position.x, player.position.y));
			
			//for each (var room:Room in world.rooms)
			//	terminal.write(room.distance + "", room.worldPosition.x + 1, room.worldPosition.y + 1);
			
			drawHud();
			terminal.paint();
		}
		
		public function handleAnimation(animation:Arrow):void 
		{
			animation.update(terminal);
			terminal.paint();
		}
		
		private function drawHud():void
		{
			var x:int = 81;
			var y:int = 1;
			
			terminal.write(player.endPiecesPickedUp + "/3 amulet pieces", x, y += 2);
		}
		
		private function item_glyph(endPiece:EndPiece):String
		{
			return "*";
		}
		
		private function item_color(endPiece:EndPiece):int
		{
			return hsv(60, 90, 90);
		}
		
		private function tile(x:int, y:int):String
		{
			switch (world.getTile(x, y))
			{
				case Tile.grass: return String.fromCharCode(250);
				case Tile.tree: return String.fromCharCode(6);
				case Tile.door_opened: return "/";
				case Tile.door_closed: return "+";
				case Tile.wall: return "#";
				case Tile.floor_light: return String.fromCharCode(250);
				case Tile.floor_dark: return String.fromCharCode(250);
				default: return "X";
			}
		}
		
		private function fg(x:int, y:int):int
		{
			switch (world.getTile(x, y))
			{
				case Tile.grass: return hsv(100, 33, 20 + Math.floor((perlinBitmap.getPixel(x, y) & 0xFF) / 255.0 * 6));
				case Tile.tree: return hsv(30 + Math.floor((perlinBitmap.getPixel(y, x) & 0xFF) / 255.0 * 90), 40, 40);
				case Tile.door_opened: return wood_fg;
				case Tile.door_closed: return wood_fg;
				case Tile.wall: return stone_fg;
				case Tile.floor_dark: return tile_3;
				case Tile.floor_light: return tile_4;
				default: return 0xff0000;
			}
		}
		
		private function bg(x:int, y:int):int
		{
			switch (world.getTile(x, y))
			{
				case Tile.grass: return hsv(100, 33, 15 + Math.floor((perlinBitmap.getPixel(x, y) & 0xFF) / 255.0 * 6));
				case Tile.tree: return hsv(100, 33, 15 + Math.floor((perlinBitmap.getPixel(x, y) & 0xFF) / 255.0 * 6));
				case Tile.door_opened: return wood_bg;
				case Tile.door_closed: return wood_bg;
				case Tile.wall: return stone_bg;
				case Tile.floor_dark: return tile_1;
				case Tile.floor_light: return tile_2;
				default: return 0x00ff00;
			}
		}
		
		
		
		public static function hsv(h:Number, s:Number, v:Number):uint
		{
			 var r:Number, g:Number, b:Number, i:Number, f:Number, p:Number, q:Number, t:Number;
			 h %= 360;
			 if (v == 0) 
				return rgb(0, 0, 0);
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
			 
			 return rgb(Math.floor(r*255), Math.floor(g*255), Math.floor(b*255));
		}
		
		public static function rgb (r:int, g:int, b:int):uint
		{
			return (255 << 24) | (r << 16) | (g << 8) | b;
		}
		
		public static function lerp(c1:int, c2:int, percent:Number):int
		{
			var r1:int = (c1 >> 16) & 0xFF;
			var g1:int = (c1 >> 8) & 0xFF;
			var b1:int = c1 & 0xFF;
			var r2:int = (c2 >> 16) & 0xFF;
			var g2:int = (c2 >> 8) & 0xFF;
			var b2:int = c2 & 0xFF;
			
			var inverse:Number = 1 - percent;
			
			return rgb(r1 * percent + r2 * inverse, g1 * percent + g2 * inverse, b1 * percent + b2 * inverse);
		}
	}
}