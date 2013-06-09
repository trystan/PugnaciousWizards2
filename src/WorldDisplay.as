package  
{
	import animations.Explosion;
	import animations.MagicMissileProjectile;
	import animations.MagicMissileProjectileTrail;
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import animations.FloorSpike;
	import animations.Arrow;
	import flash.utils.Dictionary;
	import payloads.Fire;
	import payloads.Ice;
	import payloads.Payload;
	import payloads.Pierce;
	import spells.FireJump;
	import spells.Spell;
	
	public class WorldDisplay extends Sprite
	{
		public var player:Creature;
		public var world:World;
		private var terminal:AsciiPanel;
		public var grassBackgroundBitmap:BitmapData;
		public var grassForegroundBitmap:BitmapData;
		public var treeBitmap:BitmapData;
		
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
		private var blood:int = hsv(0, 66, 20);
		private var memory:int = hsv(240, 75, 5);
		private var ice:int = hsv(220, 33, 66);
		private var fire:int = hsv(15, 66, 66);
		private var magic:int = hsv(260, 66, 99);
		private var ash:int = hsv(30, 66, 10);
		
		public function WorldDisplay(player:Creature, world:World) 
		{
			this.player = player;
			this.world = world;
			
			var perlinBitmap:BitmapData = new BitmapData(80, 80, false, 0x00CCFFCC);
			perlinBitmap.perlinNoise(6, 6, 6, Math.floor(Math.random() * int.MAX_VALUE), false, true, 1, true, null);
			
			precalculateGrassForeground(perlinBitmap);		
			precalculateGrassBackground(perlinBitmap);
			precalculateTreeForeground();
		}
		
		public function draw(terminal:AsciiPanel, header:String = null, footer:String = null):void
		{
			terminal.clear();
			
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
			{
				if (player.canSee(x, y))
					terminal.write(tileAt(x, y), x, y, fgAt(x, y), bgAt(x, y));
				else if (player.hasSeen(x, y))
				{
					var remembered:Tile = player.memory(x, y);
					terminal.write(tile(remembered), x, y, lerp(memory, fg(remembered, x, y), 0.5), lerp(memory, bg(remembered, x, y), 0.5));
				}
			}
			
			for each (var placedItem:Object in world.items)
			{
				if (player.canSee(placedItem.x, placedItem.y))
					terminal.write(item_glyph(placedItem.item), placedItem.x, placedItem.y, item_color(placedItem.item), bgAt(placedItem.x, placedItem.y));
			}
			
			
			for each (var creature:Creature in world.creatures)
			{
				if (!player.canSee(creature.position.x, creature.position.y))
					continue;	
				
				var creatureGlyph:String = creature.type == "Hero" ? "@" : creature.type.charAt(0).toLowerCase();
				var creatureColor:int = creature.type == "Hero" ? 0xffffff : 0xc0c0c0;
				if (creature.fireCounter > 0)
					creatureColor = lerp(fire, creatureColor, 0.80);
				else if (creature.freezeCounter > 0)
					creatureColor = lerp(ice, creatureColor, 0.80);
				terminal.write(creatureGlyph, creature.position.x, creature.position.y, creatureColor, bgAt(creature.position.x, creature.position.y));
			}
			
			drawAnimations(terminal);
			
			drawHud(terminal);
			
			if (header != null)
				terminal.writeCenter(header, 1, 0xffffff);
			
			if (footer != null)
				terminal.writeCenter(footer, 78, 0xffffff);
		}
		
		private static var NS:String = String.fromCharCode(179);
		private static var WE:String = String.fromCharCode(196);
		private static var NW_SE:String = "\\";
		private static var SW_NE:String = "/";
		private static var floor_arrow:String = String.fromCharCode(24); // (94);
		
		public function drawAnimations(terminal:AsciiPanel):Boolean 
		{
			var didDrawAny:Boolean = false;
			
			for each (var effect:Object in world.animationEffects)
			{
				if (effect is Arrow)
				{
					if (!player.canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;
					
					var fgc:int = payloadColor(effect.payload);
					var bgc:int = bgAt(effect.x, effect.y);
					
					if (!(effect.payload is Pierce))
						bgc = lerp(fgc, bgc, 0.25);
					
					terminal.write(arrowTile(effect.direction), effect.x, effect.y, fgc, bgc);
				}
				else if (effect is Explosion)
				{
					for each (var t:Point in effect.tiles)
					{
						if (!player.canSee(t.x, t.y))
							continue;
					
						didDrawAny = true;
						
						terminal.write(
							tileAt(t.x, t.y), 
							t.x, 
							t.y, 
							lerp(fire, fgAt(t.x, t.y), 0.4), 
							lerp(fire, bgAt(t.x, t.y), 0.4));
					}
					for each (var t2:Point in effect.frontiers)
					{
						if (!player.canSee(t2.x, t2.y))
							continue;
					
						didDrawAny = true;
						
						terminal.write(
							tileAt(t2.x, t2.y), 
							t2.x, 
							t2.y, 
							lerp(fire, fgAt(t2.x, t2.y), 0.5), 
							lerp(fire, bgAt(t2.x, t2.y), 0.5));
					}
				}
				else if (effect is MagicMissileProjectile)
				{
					if (!player.canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;

					terminal.write(
						arrowTile(effect.direction), 
						effect.x, 
						effect.y, 
						magic, 
						lerp(magic, bgAt(effect.x, effect.y), 0.3));
				}
				else if (effect is MagicMissileProjectileTrail)
				{
					if (!player.canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;

					terminal.write(
						arrowTile(effect.direction), 
						effect.x, 
						effect.y, 
						lerp(magic, fgAt(effect.x, effect.y), 0.2),
						lerp(magic, bgAt(effect.x, effect.y), 0.1));
				}
				else
				{
					if (!player.canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;

					terminal.write(floor_arrow, effect.x, effect.y, metal_fg, bgAt(effect.x, effect.y));
				}
			}
			return didDrawAny;
		}
		
		private function arrowTile(direction:String):String
		{
			switch (direction)
			{
				case "N": 
				case "S": 
					return NS;
				case "W": 
				case "E": 
					return WE;
				case "NW": return NW_SE;
				case "NE": return SW_NE;
				case "SW": return SW_NE;
				case "SE": return NW_SE;
			}
			return "*";
		}
		
		private function drawHud(terminal:AsciiPanel):void
		{
			var x:int = 81;
			var y:int = 1;
			var color:int = lerp(0xffffff, 0xff6666, 1.0 * player.health / player.maxHealth);
			terminal.write(player.health + "/" + player.maxHealth + " health", x, y += 2, color);
			
			if (player.fireCounter > 0)
				terminal.write("on fire!", x + 1, y + 2, lerp(fire, 0xffffff, 0.5));
			else if (player.freezeCounter > 0)
				terminal.write("frozen!", x + 1, y + 2, lerp(ice, 0xffffff, 0.5));
			y += 2;
			if (player.bleedingCounter > 0)
				terminal.write("bleeding!", x + 1, y + 2, lerp(blood, 0xffffff, 0.5));
			y += 2;
			
			terminal.write(player.endPiecesPickedUp + "/3 amulet pieces", x, y += 2, item_color(null));
			
			y += 2;
			
			terminal.write("--- magic ---", x, y += 2);
			
			var i:int = 1;
			for each (var magic:Spell in player.magic)
				terminal.write((i++) + " " + magic.name, x, y += 2);
		}
		
		private function payloadColor(payload:Payload):int
		{
			if (payload is Ice)
				return ice;
			else if (payload is Fire)
				return fire;
			else
				return metal_fg;
		}
		
		private function item_glyph(item:Item):String
		{
			return item is EndPiece ? "*" : "?";
		}
		
		private function item_color(item:Item):int
		{
			return item is EndPiece ? hsv(60, 90, 90) : 0xffffff;
		}
		
		private function tileAt(x:int, y:int):String
		{
			return tile(world.getTile(x, y));
		}
		private function tile(tile:Tile):String
		{
			switch (tile)
			{
				case Tile.out_of_bounds: return " ";
				case Tile.grass: return dot;
				case Tile.grass_fire: return dot;
				case Tile.burnt_ground: return dot;
				case Tile.tree: return tree;
				case Tile.tree_fire_3: return tree;
				case Tile.tree_fire_2: return tree;
				case Tile.tree_fire_1: return tree;
				case Tile.door_opened:
				case Tile.door_opened_fire: return "/";
				case Tile.door_closed:
				case Tile.door_closed_fire: return "+";
				case Tile.wall: return "#";
				case Tile.moving_wall: return "#";
				case Tile.floor_light: return dot;
				case Tile.floor_dark: return dot;
				case Tile.ice_tower:
				case Tile.fire_tower:
				case Tile.tower: return tower;
				case Tile.ice_tower_1:
				case Tile.fire_tower_1:
				case Tile.tower_1: return NS;
				case Tile.ice_tower_2:
				case Tile.fire_tower_2:
				case Tile.tower_2: return SW_NE;
				case Tile.ice_tower_3:
				case Tile.fire_tower_3:
				case Tile.tower_3: return WE;
				case Tile.ice_tower_4:
				case Tile.fire_tower_4:
				case Tile.tower_4: return NW_SE;
				case Tile.track_light_ns: return String.fromCharCode(179);
				case Tile.track_dark_ns: return String.fromCharCode(179);
				case Tile.track_light_we: return String.fromCharCode(196);
				case Tile.track_dark_we: return String.fromCharCode(196);
				default: return "X";
			}
		}
		
		private function fgAt(x:int, y:int):int
		{
			return lerp(blood, fg(world.getTile(x, y), x, y), world.getBlood(x, y) / 10.0);
		}
		
		private function fg(tile:Tile, x:int = 0, y:int = 0):int
		{
			switch (tile)
			{
				case Tile.grass: return grassForegroundBitmap.getPixel(x, y);
				case Tile.grass_fire: return lerp(fire, grassForegroundBitmap.getPixel(x, y), 0.5);
				case Tile.tree: return treeBitmap.getPixel(x, y);
				case Tile.tree_fire_3: return lerp(fire, treeBitmap.getPixel(x, y), 0.2);
				case Tile.tree_fire_2: return lerp(fire, treeBitmap.getPixel(x, y), 0.4);
				case Tile.tree_fire_1: return lerp(fire, treeBitmap.getPixel(x, y), 0.6);
				case Tile.door_opened: return wood_fg;
				case Tile.door_closed: return wood_fg;
				case Tile.door_opened_fire: return lerp(fire, wood_bg, 0.3);
				case Tile.door_closed_fire: return lerp(fire, wood_bg, 0.3);
				case Tile.wall: return stone_fg;
				case Tile.moving_wall: return lerp(0x000000, stone_fg, 0.66);
				case Tile.floor_dark: return tile_3;
				case Tile.floor_light: return tile_4;
				case Tile.ice_tower:
				case Tile.ice_tower_1:
				case Tile.ice_tower_2:
				case Tile.ice_tower_3:
				case Tile.ice_tower_4:
					return ice;
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
				case Tile.burnt_ground: return lerp(ash, grassForegroundBitmap.getPixel(x, y), 0.5);
				case Tile.track_light_ns: return 0x111111;
				case Tile.track_dark_ns: return 0x111111;
				case Tile.track_light_we: return 0x111111;
				case Tile.track_dark_we: return 0x111111;
				default: return 0xff0000;
			}
		}

		private function bgAt(x:int, y:int):int
		{
			return lerp(blood, bg(world.getTile(x, y), x, y), world.getBlood(x, y) / 10.0);
		}
		
		private function bg(tile:Tile, x:int = 0, y:int = 0):int
		{
			switch (tile)
			{
				case Tile.grass: return grassBackgroundBitmap.getPixel(x, y);
				case Tile.grass_fire: return lerp(fire, grassBackgroundBitmap.getPixel(x, y), 0.5);
				case Tile.tree: return grassBackgroundBitmap.getPixel(x, y);
				case Tile.tree_fire_3: return lerp(fire, grassBackgroundBitmap.getPixel(x, y), 0.3);
				case Tile.tree_fire_2: return lerp(fire, grassBackgroundBitmap.getPixel(x, y), 0.4);
				case Tile.tree_fire_1: return lerp(fire, grassBackgroundBitmap.getPixel(x, y), 0.5);
				case Tile.door_opened: return wood_bg;
				case Tile.door_closed: return wood_bg;
				case Tile.door_opened_fire: return lerp(fire, wood_bg, 0.5);
				case Tile.door_closed_fire: return lerp(fire, wood_bg, 0.5);
				case Tile.wall: return stone_bg;
				case Tile.moving_wall: return lerp(0x000000, stone_bg, 0.33);
				case Tile.floor_dark: return tile_1;
				case Tile.floor_light: return tile_2;
				case Tile.ice_tower:
				case Tile.ice_tower_1:
				case Tile.ice_tower_2:
				case Tile.ice_tower_3:
				case Tile.ice_tower_4:
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
				case Tile.burnt_ground: return lerp(ash, grassBackgroundBitmap.getPixel(x, y), 0.5);
				case Tile.track_light_ns: return tile_2;
				case Tile.track_dark_ns: return tile_1;
				case Tile.track_light_we: return tile_2;
				case Tile.track_dark_we: return tile_1;
				default: return 0x00ff00;
			}
		}
		
		private function precalculateGrassForeground(perlinBitmap:BitmapData):void 
		{
			grassForegroundBitmap = new BitmapData(80, 80, false, 0x00ff00);
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				grassForegroundBitmap.setPixel(x, y, hsv(100, 33, 20 + Math.floor((perlinBitmap.getPixel(x, y) & 0xFF) / 255.0 * 10)));
		}
		
		private function precalculateGrassBackground(perlinBitmap:BitmapData):void 
		{
			grassBackgroundBitmap = new BitmapData(80, 80, false, 0x00ff00);
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				grassBackgroundBitmap.setPixel(x, y, hsv(100, 33, 15 + Math.floor((perlinBitmap.getPixel(x, y) & 0xFF) / 255.0 * 10)));
		}
		
		private function precalculateTreeForeground():void 
		{
			var perlinBitmap:BitmapData = new BitmapData(80, 80, false, 0x00CCFFCC);
			perlinBitmap.perlinNoise(6, 6, 6, Math.floor(Math.random() * int.MAX_VALUE), false, true, 1, true, null);
			
			treeBitmap = new BitmapData(80, 80, false, 0x00ff00);
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				treeBitmap.setPixel(x, y, hsv(30 + Math.floor((perlinBitmap.getPixel(y, x) & 0xFF) / 255.0 * 90), 40, 40));
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