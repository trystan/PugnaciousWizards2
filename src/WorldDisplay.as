package  
{
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import animations.FloorSpike;
	import animations.Arrow;
	import flash.utils.Dictionary;
	import payloads.Fire;
	import payloads.Magic;
	import payloads.Payload;
	import payloads.Pierce;
	
	public class WorldDisplay extends Sprite
	{
		public var player:Player;
		public var world:World;
		private var terminal:AsciiPanel;
		public var perlinBitmap:BitmapData;
		
		private var dot:String = String.fromCharCode(250);
		private var tree:String = String.fromCharCode(6);
		private var tower:String = String.fromCharCode(7);
		
		private var wood_bg:int = hsv(25, 80, 30);
		private var wood_fg:int = hsv(25, 80, 50);
		private var stone_bg:int = hsv(200, 5, 30);
		private var stone_fg:int = hsv(200, 5, 40);
		private var tile_1:int = hsv(200, 5, 10);
		private var tile_2:int = hsv(200, 5, 12);
		private var tile_3:int = hsv(200, 5, 12);
		private var tile_4:int = hsv(200, 5, 14);
		private var metal_fg:int = hsv(240, 20, 90);
		private var blood:int = hsv(5, 66, 20);
		private var memory:int = hsv(240, 75, 5);
		private var magic:int = hsv(240, 50, 50);
		private var fire:int = hsv(0, 66, 50);
		
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
		
		public function draw(header:String = null, footer:String = null):void
		{
			terminal.clear();
			
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
			{
				if (player.canSee(x, y))
					terminal.write(tile(x, y), x, y, fg(x, y), bg(x, y));
				else if (player.hasSeen(x, y))
					terminal.write(tile(x, y), x, y, lerp(memory, fg(x, y), 0.5), lerp(memory, bg(x, y), 0.5));
			}
			
			for each (var placedItem:Object in world.items)
			{
				if (player.canSee(placedItem.x, placedItem.y))
					terminal.write(item_glyph(placedItem.item), placedItem.x, placedItem.y, item_color(placedItem.item), bg(placedItem.x, placedItem.y));
			}
			
			var playerColor:int = 0xffffff;
			if (player.fireCounter > 0)
				playerColor = lerp(fire, playerColor, 0.80);
			terminal.write("@", player.position.x, player.position.y, playerColor, bg(player.position.x, player.position.y));
			
			//for each (var room:Room in world.rooms)
			//	terminal.write(room.distance + "", room.worldPosition.x + 1, room.worldPosition.y + 1);
			
			drawHud();
			
			if (header != null)
				terminal.write(header, (80 - footer.length) / 2, 1, 0xffffff);
			
			if (footer != null)
				terminal.write(footer, (80 - footer.length) / 2, 78, 0xffffff);
			
			terminal.paint();
		}
		
		private static var NS:String = String.fromCharCode(179);
		private static var WE:String = String.fromCharCode(196);
		private static var NW_SE:String = "\\";
		private static var SW_NE:String = "/";
		private static var floor_arrow:String = String.fromCharCode(24); // (94);
		
		public function animateOneFrame():Boolean 
		{
			var didDrawAny:Boolean = false;
			
			for each (var effect:Object in world.animationEffects)
			{
				if (!player.canSee(effect.x, effect.y))
					continue;
				
				didDrawAny = true;
				
				if (effect is Arrow)
				{
					var fgc:int = payloadColor(effect.payload);
					var bgc:int = bg(effect.x, effect.y);
					
					if (!(effect.payload is Pierce))
						bgc = lerp(magic, bgc, 0.25);
					
					switch (effect.direction)
					{
						case "N": terminal.write(NS, effect.x, effect.y, fgc, bgc); break;
						case "S": terminal.write(NS, effect.x, effect.y, fgc, bgc); break;
						case "W": terminal.write(WE, effect.x, effect.y, fgc, bgc); break;
						case "E": terminal.write(WE, effect.x, effect.y, fgc, bgc); break;
						case "NW": terminal.write(NW_SE, effect.x, effect.y, fgc, bgc); break;
						case "NE": terminal.write(SW_NE, effect.x, effect.y, fgc, bgc); break;
						case "SW": terminal.write(SW_NE, effect.x, effect.y, fgc, bgc); break;
						case "SE": terminal.write(NW_SE, effect.x, effect.y, fgc, bgc); break;
					}
				}
				else
				{
					terminal.write(floor_arrow, effect.x, effect.y, metal_fg, bg(effect.x, effect.y));
				}
			}
			if (didDrawAny)
				terminal.paint();
			return didDrawAny;
		}
		
		private function drawHud():void
		{
			var x:int = 81;
			var y:int = 1;
			
			terminal.write(player.health + "/" + player.maxHealth + " health", x, y += 2);
			
			terminal.write(player.endPiecesPickedUp + "/3 amulet pieces", x, y += 2);
		}
		
		private function payloadColor(payload:Payload):int
		{
			if (payload is Magic)
				return magic;
			else if (payload is Fire)
				return fire;
			else
				return metal_fg;
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
				case Tile.grass: return dot;
				case Tile.tree: return tree;
				case Tile.door_opened: return "/";
				case Tile.door_closed: return "+";
				case Tile.wall: return "#";
				case Tile.floor_light: return dot;
				case Tile.floor_dark: return dot;
				case Tile.magic_tower:
				case Tile.fire_tower:
				case Tile.tower: return tower;
				case Tile.magic_tower_1:
				case Tile.fire_tower_1:
				case Tile.tower_1: return NS;
				case Tile.magic_tower_2:
				case Tile.fire_tower_2:
				case Tile.tower_2: return SW_NE;
				case Tile.magic_tower_3:
				case Tile.fire_tower_3:
				case Tile.tower_3: return WE;
				case Tile.magic_tower_4:
				case Tile.fire_tower_4:
				case Tile.tower_4: return NW_SE;
				default: return "X";
			}
		}
		
		private function fg(x:int, y:int):int
		{
			return lerp(blood, raw_fg(x, y), world.getBlood(x, y) / 10.0);
		}
		
		private function raw_fg(x:int, y:int):int
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
				case Tile.magic_tower:
				case Tile.magic_tower_1:
				case Tile.magic_tower_2:
				case Tile.magic_tower_3:
				case Tile.magic_tower_4:
					return magic;
				case Tile.tower:
				case Tile.tower_1:
				case Tile.tower_2:
				case Tile.tower_3:
				case Tile.tower_4:
					return metal_fg;
				case Tile.fire_tower:
				case Tile.fire_tower_1:
				case Tile.fire_tower_2:
				case Tile.fire_tower_3:
				case Tile.fire_tower_4:
					return fire;
				default: return 0xff0000;
			}
		}
		
		private function bg(x:int, y:int):int
		{
			return lerp(blood, raw_bg(x, y), world.getBlood(x, y) / 10.0);
		}
		
		private function raw_bg(x:int, y:int):int
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
				case Tile.magic_tower:
				case Tile.magic_tower_1:
				case Tile.magic_tower_2:
				case Tile.magic_tower_3:
				case Tile.magic_tower_4:
				case Tile.fire_tower:
				case Tile.fire_tower_1:
				case Tile.fire_tower_2:
				case Tile.fire_tower_3:
				case Tile.fire_tower_4:
				case Tile.tower:
				case Tile.tower_1:
				case Tile.tower_2:
				case Tile.tower_3:
				case Tile.tower_4:
					return stone_fg;
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
			var key:String = c1 + "," + c2 + "," + percent;
			var value:Object = lerp_cache[key];
			
			if (value == null)
			{
				value = lerp_real(c1, c2, percent);
				lerp_cache[key] = value;
			}
			
			return (int)(value);
		}
		
		private static var lerp_cache:Dictionary = new Dictionary();
		public static function lerp_real(c1:int, c2:int, percent:Number):int
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