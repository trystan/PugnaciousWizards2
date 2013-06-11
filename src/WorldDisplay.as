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
	import knave.Color;
	
	public class WorldDisplay extends Sprite
	{
		public var player:Creature;
		public var world:World;
		public var grassBackgroundBitmap:BitmapData;
		public var grassForegroundBitmap:BitmapData;
		public var treeBitmap:BitmapData;
		
		private var dot:String = String.fromCharCode(250);
		private var tree:String = String.fromCharCode(6);
		private var tower:String = String.fromCharCode(7);
		private var water:String = String.fromCharCode(247);
		
		private var wood_bg:Color = Color.hsv(25, 80, 40);
		private var wood_fg:Color = Color.hsv(25, 80, 60);
		private var stone_bg:Color = Color.hsv(200, 5, 35);
		private var stone_fg:Color = Color.hsv(200, 5, 45);
		private var tile_1:Color = Color.hsv(200, 5, 10);
		private var tile_2:Color = Color.hsv(200, 5, 13);
		private var tile_3:Color = Color.hsv(200, 5, 13);
		private var tile_4:Color = Color.hsv(200, 5, 16);
		private var metal_fg:Color = Color.hsv(240, 20, 90);
		private var blood:Color = Color.hsv(0, 66, 35);
		private var memory:Color = Color.hsv(240, 75, 5);
		private var ice:Color = Color.hsv(220, 33, 80);
		private var fire:Color = Color.hsv(0, 75, 80);
		private var magic:Color = Color.hsv(270, 50, 80);
		private var ash:Color = Color.hsv(30, 66, 20);
		private var water_fg:Color = Color.hsv(220, 70, 50);
		private var water_bg:Color = Color.hsv(220, 50, 30);
		
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
		
		public function draw(terminal:AsciiPanel):void
		{
			terminal.clear();
			
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
			{
				if (player.canSee(x, y))
					terminal.write(tileAt(x, y), x, y, fgAt(x, y).toInt(), bgAt(x, y).toInt());
				else if (player.hasSeen(x, y))
				{
					var remembered:Tile = player.memory(x, y);
					terminal.write(
						tile(remembered, x, y), 
						x, y, 
						memory.lerp(fg(remembered, x, y), 0.5).toInt(), 
						memory.lerp(bg(remembered, x, y), 0.5).toInt());
				}
			}
			
			for each (var placedItem:Object in world.items)
			{
				if (player.canSee(placedItem.x, placedItem.y))
					terminal.write(
						item_glyph(placedItem.item), 
						placedItem.x, placedItem.y, 
						item_color(placedItem.item).toInt(), 
						terminal.getBackgroundColor(placedItem.x, placedItem.y));
			}
			
			
			for each (var creature:Creature in world.creatures)
			{
				if (!player.canSee(creature.position.x, creature.position.y))
					continue;
					
				if (creature.health < 1)
				{
					trace(creature + " health = " + creature.health);
					continue;
				}
				
				var creatureGlyph:String = creature.isGoodGuy ? "@" : creature.type.charAt(0).toLowerCase();
				var creatureColor:Color = Color.integer(creature.isGoodGuy ? 0xffffff : 0xc0c0c0);
				if (creature.fireCounter > 0)
					creatureColor = creatureColor.lerp(fire, 0.20);
				else if (creature.freezeCounter > 0)
					creatureColor = creatureColor.lerp(ice, 0.20);
				terminal.write(creatureGlyph, 
					creature.position.x, creature.position.y, 
					creatureColor.toInt(), 
					terminal.getBackgroundColor(creature.position.x, creature.position.y));
			}
			
			drawAnimations(terminal);
			
			drawHud(terminal);
			
			addGlowingTiles(terminal);
		}
		
		private var glowingTiles:Array = [
			Tile.ice_tower, Tile.ice_tower_1, Tile.ice_tower_2, Tile.ice_tower_3, Tile.ice_tower_4,
			Tile.fire_tower, Tile.fire_tower_1, Tile.fire_tower_2, Tile.fire_tower_3, Tile.fire_tower_4,
			Tile.portal,
		];
		
		private var isOnFileTiles:Array = [
			Tile.tree_fire_1, Tile.tree_fire_2, Tile.tree_fire_3,
			Tile.grass_fire, Tile.door_closed_fire, Tile.door_opened_fire,
		];
		
		private function addLight(terminal:AsciiPanel, x:int, y:int, color:Color, radius:Number = 3.0):void
		{
			for (var ox:int = -radius + 1; ox < radius; ox++)
			for (var oy:int = -radius + 1; oy < radius; oy++)
			{
				var tx:int = x + ox;
				var ty:int = y + oy;
				
				if (tx < 0 || ty < 0 || tx > 79 || ty > 79)
					continue;
				
				var dist:Number = ox * ox + oy * oy;
				if (dist > radius * radius)
					continue;
				
				if (!player.canSee(tx, ty))
					continue;
					
				var mult:Number = (1.0 - dist / (radius * radius)) * 0.1;
				
				var fore:int = terminal.getForegroundColor(tx, ty);
				var back:int = terminal.getBackgroundColor(tx, ty);
				var char:String = terminal.getCharacter(tx, ty);
				
				fore = color.lerp(Color.integer(fore), mult).toInt();
				back = color.lerp(Color.integer(back), mult).toInt();
				
				terminal.write(char, tx, ty, fore, back);
			}
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
					
					var fgc:Color = payloadColor(effect.payload);
					
					terminal.write(arrowTile(effect.direction), effect.x, effect.y, fgc.toInt(), terminal.getBackgroundColor(effect.x, effect.y));
					
					if (!(effect.payload is Pierce))
						addLight(terminal, effect.x, effect.y, payloadColor(effect.payload), 2);
				}
				else if (effect is Explosion)
				{
					for each (var t:Point in effect.tiles)
					{
						if (!player.canSee(t.x, t.y))
							continue;
					
						didDrawAny = true;
						
						terminal.write(
							terminal.getCharacter(t.x, t.y),
							t.x, 
							t.y, 
							fire.lerp(Color.integer(terminal.getForegroundColor(t.x, t.y)), 0.5).toInt(), 
							fire.lerp(Color.integer(terminal.getBackgroundColor(t.x, t.y)), 0.5).toInt());
					}
					for each (var t2:Point in effect.frontiers)
					{
						if (!player.canSee(t2.x, t2.y))
							continue;
					
						didDrawAny = true;
						
						terminal.write(
							terminal.getCharacter(t2.x, t2.y),
							t2.x, 
							t2.y, 
							fire.lerp(Color.integer(terminal.getForegroundColor(t2.x, t2.y)), 0.3).toInt(), 
							fire.lerp(Color.integer(terminal.getBackgroundColor(t2.x, t2.y)), 0.3).toInt());
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
						magic.toInt(), 
						terminal.getBackgroundColor(effect.x, effect.y));
						
					addLight(terminal, effect.x, effect.y, magic, 2);
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
						magic.toInt(), 
						terminal.getBackgroundColor(effect.x, effect.y));
						
					addLight(terminal, effect.x, effect.y, magic, 2);
				}
				else
				{
					if (!player.canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;

					terminal.write(floor_arrow, effect.x, effect.y, metal_fg.toInt(), bgAt(effect.x, effect.y).toInt());
				}
			}
			
			return didDrawAny;
		}
		
		private function addGlowingTiles(terminal:AsciiPanel):void
		{
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
			{
				var tile:Tile = world.getTile(x, y);
				if (glowingTiles.indexOf(tile) > -1)
					addLight(terminal, x, y, fgAt(x, y), 3);
				else if (isOnFileTiles.indexOf(tile) > -1)
					addLight(terminal, x, y, fire, 3);
			}
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
			return " ";
		}
		
		private function drawHud(terminal:AsciiPanel):void
		{
			var x:int = 81;
			var y:int = 1;
			var white:Color = Color.integer(0xffffff);
			var color:Color = white.lerp(Color.integer(0xff6666), 1.0 * player.health / player.maxHealth);
			terminal.write(player.health + "/" + player.maxHealth + " health", x, y += 2, color.toInt());
			
			if (player.fireCounter > 0)
				terminal.write("on fire!", x + 1, y + 2, fire.lerp(white, 0.5).toInt());
			else if (player.freezeCounter > 0)
				terminal.write("frozen!", x + 1, y + 2, ice.lerp(white, 0.5).toInt());
			y += 2;
			if (player.bleedingCounter > 0)
				terminal.write("bleeding!", x + 1, y + 2, blood.lerp(white, 0.5).toInt());
			y += 2;
			
			terminal.write(player.endPiecesPickedUp + "/3 amulet pieces", x, y += 2, item_color(null).toInt());
			
			y += 2;
			terminal.write("--- help ---", x, y += 2);
			terminal.write("?   help screen", x, y += 2);
			terminal.write("x   examine", x, y += 2);
			
			y += 2;
			
			var magicColor:Color = player.canCastMagic ? white : Color.integer(0x909090);
				
			terminal.write("--- magic ---", x, y += 2, magicColor.toInt());
			
			var i:int = 1;
			for each (var magic:Spell in player.magic)
				terminal.write((i++) + " " + magic.name, x, y += 2, magicColor.toInt());
		}
		
		private function payloadColor(payload:Payload):Color
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
			if (item is HealthContainer)
				return String.fromCharCode(3);
				
			return item is EndPiece ? "*" : "?";
		}
		
		private function item_color(item:Item):Color
		{
			if (item is HealthContainer)
				return Color.integer(0xff6666);
				
			return item is EndPiece ? Color.hsv(60, 90, 90) : Color.integer(0xffffff);
		}
		
		private function tileAt(x:int, y:int):String
		{
			return tile(world.getTile(x, y), x, y);
		}
		private function tile(tile:Tile, x:int = 0, y:int = 0):String
		{
			switch (tile)
			{
				case Tile.shallow_water: return water;
				case Tile.portal: return String.fromCharCode(177);
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
				case Tile.mystic_floor_light: return String.fromCharCode((x * 11 + y * 23) % 250);
				case Tile.mystic_floor_dark: return String.fromCharCode((x * 11 + y * 23) % 250);
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
		
		private function fgAt(x:int, y:int):Color
		{
			return blood.lerp(fg(world.getTile(x, y), x, y), world.getBlood(x, y) / 20.0);
		}
		
		private function fg(tile:Tile, x:int = 0, y:int = 0):Color
		{
			switch (tile)
			{
				case Tile.shallow_water: return water_fg;
				case Tile.portal: return Color.hsv(Math.random() * 360, 50, 90);
				case Tile.grass: return Color.integer(grassForegroundBitmap.getPixel(x, y));
				case Tile.grass_fire: return fire.lerp(Color.integer(grassForegroundBitmap.getPixel(x, y)), 0.33);
				case Tile.tree: return Color.integer(treeBitmap.getPixel(x, y));
				case Tile.tree_fire_3: return fire.lerp(Color.integer(treeBitmap.getPixel(x, y)), 0.1);
				case Tile.tree_fire_2: return fire.lerp(Color.integer(treeBitmap.getPixel(x, y)), 0.3);
				case Tile.tree_fire_1: return fire.lerp(Color.integer(treeBitmap.getPixel(x, y)), 0.5);
				case Tile.door_opened: return wood_fg;
				case Tile.door_closed: return wood_fg;
				case Tile.door_opened_fire: return fire.lerp(wood_bg, 0.2);
				case Tile.door_closed_fire: return fire.lerp(wood_bg, 0.2);
				case Tile.wall: return stone_fg;
				case Tile.moving_wall: return Color.integer(0xffffff).lerp(stone_fg, 0.50);
				case Tile.floor_dark: return tile_3;
				case Tile.floor_light: return tile_4;
				case Tile.mystic_floor_dark: return magic.lerp(Color.integer(0x000000), 0.33);
				case Tile.mystic_floor_light: return magic.lerp(Color.integer(0x000000), 0.33);
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
				case Tile.burnt_ground: return ash.lerp(Color.integer(grassForegroundBitmap.getPixel(x, y)), 0.5);
				case Tile.track_light_ns: return Color.integer(0x111111);
				case Tile.track_dark_ns: return Color.integer(0x111111);
				case Tile.track_light_we: return Color.integer(0x111111);
				case Tile.track_dark_we: return Color.integer(0x111111);
				default: return Color.integer(0x110000);
			}
		}

		private function bgAt(x:int, y:int):Color
		{
			return blood.lerp(bg(world.getTile(x, y), x, y), world.getBlood(x, y) / 10.0);
		}
		
		private function bg(tile:Tile, x:int = 0, y:int = 0):Color
		{
			switch (tile)
			{				
				case Tile.shallow_water: return water_bg;
				case Tile.portal: return Color.hsv(Math.random() * 360, 50, 90);
				case Tile.grass: return Color.integer(grassBackgroundBitmap.getPixel(x, y));
				case Tile.grass_fire: return fire.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.33);
				case Tile.tree: return Color.integer(grassBackgroundBitmap.getPixel(x, y));
				case Tile.tree_fire_3: return fire.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.1);
				case Tile.tree_fire_2: return fire.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.3);
				case Tile.tree_fire_1: return fire.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.5);
				case Tile.door_opened: return wood_bg;
				case Tile.door_closed: return wood_bg;
				case Tile.door_opened_fire: return fire.lerp(wood_bg, 0.1);
				case Tile.door_closed_fire: return fire.lerp(wood_bg, 0.1);
				case Tile.wall: return stone_bg;
				case Tile.moving_wall: return Color.integer(0xffffff).lerp(stone_bg, 0.25);
				case Tile.floor_dark: return tile_1;
				case Tile.floor_light: return tile_2;
				case Tile.mystic_floor_dark: return tile_1;
				case Tile.mystic_floor_light: return tile_2;
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
				case Tile.burnt_ground: return ash.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.5);
				case Tile.track_light_ns: return tile_2;
				case Tile.track_dark_ns: return tile_1;
				case Tile.track_light_we: return tile_2;
				case Tile.track_dark_we: return tile_1;
				default: return Color.integer(0x00ff00);
			}
		}
		
		private function precalculateGrassForeground(perlinBitmap:BitmapData):void 
		{
			grassForegroundBitmap = new BitmapData(80, 80, false, 0x00ff00);
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				grassForegroundBitmap.setPixel(x, y, Color.hsv(100, 33, 20 + Math.floor((perlinBitmap.getPixel(x, y) & 0xFF) / 255.0 * 10)).toInt());
		}
		
		private function precalculateGrassBackground(perlinBitmap:BitmapData):void 
		{
			grassBackgroundBitmap = new BitmapData(80, 80, false, 0x00ff00);
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				grassBackgroundBitmap.setPixel(x, y, Color.hsv(100, 33, 15 + Math.floor((perlinBitmap.getPixel(x, y) & 0xFF) / 255.0 * 10)).toInt());
		}
		
		private function precalculateTreeForeground():void 
		{
			var perlinBitmap:BitmapData = new BitmapData(80, 80, false, 0x00CCFFCC);
			perlinBitmap.perlinNoise(6, 6, 6, Math.floor(Math.random() * int.MAX_VALUE), false, true, 1, true, null);
			
			treeBitmap = new BitmapData(80, 80, false, 0x00ff00);
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
				treeBitmap.setPixel(x, y, Color.hsv(30 + Math.floor((perlinBitmap.getPixel(y, x) & 0xFF) / 255.0 * 90), 40, 40).toInt());
		}
	}
}