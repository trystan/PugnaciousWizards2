package  
{
	import adobe.utils.CustomActions;
	import com.headchant.asciipanel.AsciiPanel;
	import flash.display.BitmapData;
	import flash.display.GraphicsSolidFill;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import animations.*;
	import features.*;
	import payloads.*;
	import knave.Color;
	import spells.Spell;
	
	/*
	 * I tried to keep the display details out of the domain classes and ended up with this montrosity. :( 
	 */
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
		private var tile_3:Color = Color.hsv(200, 5, 15);
		private var tile_4:Color = Color.hsv(200, 5, 18);
		private var metal_fg:Color = Color.hsv(240, 20, 90);
		private var blood:Color = Color.hsv(0, 66, 35);
		private var memory:Color = Color.hsv(240, 75, 5);
		private var ice:Color = Color.hsv(220, 50, 80);
		private var fire:Color = Color.hsv(0, 75, 80);
		private var poison:Color = Color.hsv(90, 50, 80);
		private var magic:Color = Color.hsv(270, 50, 80);
		private var gold:Color = Color.hsv(60, 50, 80);
		private var ash:Color = Color.hsv(30, 66, 20);
		private var water_fg:Color = Color.hsv(220, 70, 50);
		private var water_bg:Color = Color.hsv(220, 50, 30);
		private var white:Color = Color.integer(0xffffff);
		private var black:Color = Color.integer(0x000000);
		private var dark:Color = Color.integer(0x333333);
		private var light:Color = Color.hsv(60, 90, 90);
		
		private var viewAllMode:Boolean = false;
		
		public var spellStart:Point = new Point(100,100);
		public var helpStart:Point = new Point(100,100);
		
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
		
		private function canSee(x:int, y:int):Boolean
		{
			return viewAllMode || player.canSee(x, y);
		}
		
		public function draw(terminal:AsciiPanel):void
		{
			terminal.clear();
			
			for (var x:int = 0; x < 80; x++)
			for (var y:int = 0; y < 80; y++)
			{
				if (canSee(x, y))
				{
					terminal.write(tileAt(x, y), x, y, fgAt(x, y).toInt(), bgAt(x, y).toInt());
					
					var visibleTile:Tile = world.getTile(x, y);
					if (visibleTile.description != null)
						popup(visibleTile.name, 
								popupTitle(visibleTile.name, tileAt(x, y)),
								visibleTile.description);
								
					if (isOnFileTiles.indexOf(visibleTile) > -1)
						popup("something is on fire", 
								popupTitle(visibleTile.name, tileAt(x, y)),
								"Some things can catch on fire. Fire can easy spread out of control - which I'm sure you'll find out about.");
				}
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
			
			for each (var placedItem:ItemInWorld in world.items)
			{
				if (canSee(placedItem.x, placedItem.y))
				{
					popup(placedItem.item.name, 
						popupTitle(placedItem.item.name, item_glyph(placedItem.item)),
						placedItem.item.description);
					
					terminal.write(
						item_glyph(placedItem.item), 
						placedItem.x, placedItem.y, 
						item_color(placedItem.item).toInt(), 
						terminal.getBackgroundColor(placedItem.x, placedItem.y));
				}
			}
			
			for each (var creature:Creature in world.creatures)
			{
				if (!canSee(creature.position.x, creature.position.y) && player != creature)
					continue;
				
				var creatureGlyph:String = getCreatureGlyph(creature);
				
				var creatureColor:Color = getCreatureColor(creature);
				
				terminal.write(creatureGlyph, 
					creature.position.x, creature.position.y, 
					creatureColor.toInt(), 
					terminal.getBackgroundColor(creature.position.x, creature.position.y));
				
				popup(creature.type, 
						popupTitle(creature.type, creatureGlyph),
						creature.description);
			}
			
			drawFeatures(terminal);
			
			drawAnimations(terminal);
			
			drawHud(terminal);
			
			addGlowingTiles(terminal);
		}
		
		private function getCreatureColor(creature:Creature):Color 
		{
			var creatureColor:Color = Color.integer(creature.isGoodGuy ? 0xffffff : 0xc0c0c0);
				
			if (creature is AngryTree)
				creatureColor = fg(Tile.tree, 1, 1);
			else if (creature is BloodJelly)
				creatureColor = blood.lerp(white, 0.5);
			else if (creature is Golem)
				creatureColor = stone_fg;
			
			if (creature.fireCounter > 0)
				creatureColor = creatureColor.lerp(fire, 0.20);
			else if (creature.freezeCounter > 0)
				creatureColor = creatureColor.lerp(ice, 0.20);
				
			return creatureColor;
		}
		
		private function getCreatureGlyph(creature:Creature):String 
		{
			var creatureGlyph:String = creature.isGoodGuy ? "@" : creature.type.charAt(0).toLowerCase();
			if (creature is AngryTree)
				creatureGlyph = tile(Tile.tree);
			if (creature is Golem)
				creatureGlyph = "G";
			return creatureGlyph;
		}
		
		private function popupTitle(thing:String, glyph:String):String
		{
			if ("aeiouy".indexOf(thing.charAt(0).toLowerCase()) == -1)
				return "You see a " + thing + " (" + glyph + ")";
			else
				return "You see an " + thing + " (" + glyph + ")";
		}
		
		private function popup(topic:String, title:String, text:String):void
		{
			if (player is Player)
				HelpSystem.popup(topic, title, text);
		}
		
		private var glowingTiles:Array = [
			Tile.ice_tower, Tile.ice_tower_1, Tile.ice_tower_2, Tile.ice_tower_3, Tile.ice_tower_4,
			Tile.fire_tower, Tile.fire_tower_1, Tile.fire_tower_2, Tile.fire_tower_3, Tile.fire_tower_4,
			Tile.portal,
		];
		
		private var isOnFileTiles:Array = [
			Tile.tree_fire_1, Tile.tree_fire_2, Tile.tree_fire_3,
			Tile.grass_fire, Tile.door_closed_fire, Tile.door_opened_fire,
			Tile.magma
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
				
				if (!canSee(tx, ty))
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
		
		private function drawFeatures(terminal:AsciiPanel):void 
		{
			for each (var feature:CastleFeature in world.featureList)
			{
				if (feature is BaseTimedEffect)
				{
					var effect:BaseTimedEffect = feature as BaseTimedEffect;
					
					if (!canSee(effect.x, effect.y))
						continue;
					
					terminal.write(effect.timer.toString(), effect.x, effect.y, 0xffffff, bgAt(effect.x, effect.y).toInt());
				}
			}
		}
		
		public function drawAnimations(terminal:AsciiPanel):Boolean 
		{
			var didDrawAny:Boolean = false;
			
			for each (var effect:Animation in world.animationList)
			{
				if (effect.done)
					continue;
				
				if (effect is Arrow)
					didDrawAny = drawArrow(terminal, effect as Arrow) || didDrawAny;
				else if (effect is Explosion)
					didDrawAny = drawExplosion(terminal, effect as Explosion) || didDrawAny;
				else if (effect is MagicMissileProjectile)
					didDrawAny = drawMagicMissileProjectile(terminal, effect as MagicMissileProjectile) || didDrawAny;
				
				else if (effect is MagicMissileProjectileTrail)
				{
					if (!canSee(effect.x, effect.y))
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
				else if (effect is PullAndFreezeProjectile)
				{
					if (!canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;

					terminal.write(
						terminal.getCharacter(effect.x, effect.y), 
						effect.x, 
						effect.y, 
						ice.lerp(Color.integer(terminal.getForegroundColor(effect.x, effect.y)), 0.5).toInt(),
						ice.lerp(Color.integer(terminal.getBackgroundColor(effect.x, effect.y)), 0.5).toInt());
				}
				else if (effect is PullAndFreezeProjectileTrail)
				{
					if (!canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;

					var trail:PullAndFreezeProjectileTrail = effect as PullAndFreezeProjectileTrail;
					terminal.write(
						terminal.getCharacter(effect.x, effect.y), 
						effect.x, 
						effect.y, 
						ice.lerp(Color.integer(terminal.getForegroundColor(effect.x, effect.y)), trail.ticks / 12.0).toInt(),
						ice.lerp(Color.integer(terminal.getBackgroundColor(effect.x, effect.y)), trail.ticks / 12.0).toInt());
				}
				else if (effect is PullAndFreezeExpansion)
				{
					var expansionRadius:int = (effect as PullAndFreezeExpansion).radius;
					for (var x0:int = effect.x - expansionRadius; x0 < effect.x + expansionRadius; x0++)
					for (var y0:int = effect.y - expansionRadius; y0 < effect.y + expansionRadius; y0++)
					{
						if (!canSee(x0, y0))
							continue;
						
						didDrawAny = true;

						terminal.write(
							terminal.getCharacter(x0, y0), 
							x0, y0,  
							ice.lerp(Color.integer(terminal.getForegroundColor(x0, y0)), 0.25).toInt(),
							ice.lerp(Color.integer(terminal.getBackgroundColor(x0, y0)), 0.25).toInt());
					}
				}
				else if (effect is Flash)
				{
					if (!canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;
					
					terminal.write(" ", effect.x, effect.y, 
							white.lerp(Color.integer(terminal.getForegroundColor(effect.x, effect.y)), 0.5).toInt(), 
							white.lerp(Color.integer(terminal.getBackgroundColor(effect.x, effect.y)), 0.5).toInt());
				}
				else if (effect is TelekeneticMovement)
				{
					if (!canSee(effect.x, effect.y))
						continue;
					
					didDrawAny = true;
					
					var item:Item = (effect as TelekeneticMovement).thing as Item;
					if (item != null)
						terminal.write(item_glyph(item), effect.x, effect.y, item_color(item).toInt(), bgAt(effect.x, effect.y).toInt());
				}
				else
				{
					if (!canSee(effect.x, effect.y))
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
			
			for each (var creature:Creature in world.creatures)
			{
				if (!(creature is EnemyWizard))
					continue;
				
				var c:EnemyWizard = creature as EnemyWizard;
				
				var color:Color = payloadColor(c.aura).lerp(light, 0.66);
				addLight(terminal, c.position.x, c.position.y, color, 5);
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
			return "?";
		}
		
		private function drawHud(terminal:AsciiPanel):void
		{
			var x:int = 81;
			var y:int = 1;
			var color:Color = white.lerp(Color.integer(0xff6666), 1.0 * player.health / player.maxHealth);
			terminal.write(String.fromCharCode(3) + " ", x, y += 2, Color.integer(0xff6666).toInt());
			terminal.write(player.health + "/" + player.maxHealth, x + 2, y, color.toInt());
			
			terminal.write("$ " + player.gold, x, y += 2, gold.toInt());
			
			terminal.write("* " + player.numberOfAmuletsPickedUp + "/3", x, y += 2, Color.hsv(60, 90, 90).toInt());
			
			if (player.fireCounter > 0)
				terminal.write("on fire! (" + player.fireCounter + ")", x + 1, y + 2, fire.lerp(white, 0.5).toInt());
			else if (player.freezeCounter > 0)
				terminal.write("frozen! (" + player.freezeCounter + ")", x + 1, y + 2, ice.lerp(white, 0.5).toInt());
			y += 2;
			if (player.bleedingCounter > 0)
				terminal.write("bleeding! (" + player.bleedingCounter + ")", x + 1, y += 2, blood.lerp(white, 0.5).toInt());
			if (player.blindCounter > 0)
				terminal.write("blind! (" + player.blindCounter + ")", x + 1, y += 2, 0xc0c0ff);
			if (player.poisonCounter > 0)
				terminal.write("poisoned! (" + player.poisonCounter + ")", x + 1, y += 2, 0xc0ffc0);
			
			y = 17;
			terminal.write("--- help ---", x, y += 2);
			terminal.write("? help", x, y += 2);
			helpStart.x = x;
			helpStart.y = y;
			terminal.write("x examine", x, y += 2);
			terminal.write("D discoveries", x, y += 2);
			
			y += 2;
			
			var magicColor:Color = player.canCastMagic ? white : Color.integer(0x909090);
				
			terminal.write("--- magic ---", x, y += 2, magicColor.toInt());
			
			spellStart.x = x;
			spellStart.y = y + 2;
			
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
			else if (payload is Poison)
				return poison;
			else
				return metal_fg;
		}
		
		private function item_glyph(item:Item):String
		{
			if (item is HealthContainer)
				return String.fromCharCode(3);
				
			if (item is PileOfBones)
				return "%";
				
			if (item is Gold)
				return "$";
				
			return item is EndPiece ? "*" : "?";
		}
		
		private function item_color(item:Item):Color
		{
			if (item is HealthContainer)
				return Color.integer(0xff6666);
				
			if (item is PileOfBones)
				return Color.integer(0x909090);
				
			if (item is Gold)
				return gold;
				
			return item is EndPiece ? gold : white;
		}
		
		private function tileAt(x:int, y:int):String
		{
			return tile(world.getTile(x, y), x, y);
		}
		
		private function tile(tile:Tile, x:int = 0, y:int = 0):String
		{
			switch (tile)
			{
				case Tile.magma: return String.fromCharCode(249);
				case Tile.golden_statue: return "s";
				case Tile.fire_trap:
				case Tile.ice_trap:
				case Tile.poison_trap: return "^";
				case Tile.poisonFog:
				case Tile.healingFog: return String.fromCharCode(177);
				case Tile.poison_water:
				case Tile.shallow_water: return water;
				case Tile.frozen_water: return "="; // String.fromCharCode(240);
				case Tile.portal: return String.fromCharCode(177);
				case Tile.out_of_bounds: return " ";
				case Tile.dirt: return dot;
				case Tile.grass: return dot;
				case Tile.grass_fire: return dot;
				case Tile.burnt_ground: return dot;
				case Tile.tree: return tree;
				case Tile.tree_fire_3: return tree;
				case Tile.tree_fire_2: return tree;
				case Tile.tree_fire_1: return tree;
				case Tile.stone_door_opened:
				case Tile.wood_door_opened:
				case Tile.door_opened_fire: return "/";
				case Tile.stone_door_closed:
				case Tile.wood_door_closed:
				case Tile.door_closed_fire: return "+";
				case Tile.wall: return "#";
				case Tile.bars_h: return String.fromCharCode(205);
				case Tile.bars_v: return String.fromCharCode(186);
				case Tile.moving_wall: return "#";
				case Tile.floor_light: return dot;
				case Tile.floor_dark: return dot;
				case Tile.mystic_floor_light: return String.fromCharCode((x * 11 + y * 23) % 250);
				case Tile.mystic_floor_dark: return String.fromCharCode((x * 11 + y * 23) % 250);
				case Tile.ice_tower:
				case Tile.fire_tower:
				case Tile.poison_tower:
				case Tile.tower: return tower;
				case Tile.ice_tower_1:
				case Tile.fire_tower_1:
				case Tile.poison_tower_1:
				case Tile.tower_1: return NS;
				case Tile.ice_tower_2:
				case Tile.fire_tower_2:
				case Tile.poison_tower_2:
				case Tile.tower_2: return SW_NE;
				case Tile.ice_tower_3:
				case Tile.fire_tower_3:
				case Tile.poison_tower_3:
				case Tile.tower_3: return WE;
				case Tile.ice_tower_4:
				case Tile.fire_tower_4:
				case Tile.poison_tower_4:
				case Tile.tower_4: return NW_SE;
				case Tile.ice_tower_5:
				case Tile.fire_tower_5:
				case Tile.poison_tower_5:
				case Tile.tower_5: return String.fromCharCode(197);
				case Tile.ice_tower_6:
				case Tile.fire_tower_6:
				case Tile.poison_tower_6:
				case Tile.tower_6: return "X";
				case Tile.track_light_ns: return String.fromCharCode(179);
				case Tile.track_dark_ns: return String.fromCharCode(179);
				case Tile.track_light_we: return String.fromCharCode(196);
				case Tile.track_dark_we: return String.fromCharCode(196);
				case Tile.track_light_ne: return String.fromCharCode(192);
				case Tile.track_dark_ne: return String.fromCharCode(192);
				case Tile.track_light_sw: return String.fromCharCode(191);
				case Tile.track_dark_sw: return String.fromCharCode(191);
				case Tile.track_light_nw: return String.fromCharCode(217);
				case Tile.track_dark_nw: return String.fromCharCode(217);
				case Tile.track_light_se: return String.fromCharCode(218);
				case Tile.track_dark_se: return String.fromCharCode(218);
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
				case Tile.magma: return Color.hsv(50 + Math.random() * 10, 70 + Math.random() * 10, 50 + Math.random() * 10);
				case Tile.golden_statue: return gold;
				case Tile.fire_trap: return fire;
				case Tile.ice_trap: return ice;
				case Tile.poison_trap: return poison;
				case Tile.healingFog: return Color.hsv(300, 66, 66);
				case Tile.poisonFog: return poison.lerp(white, 0.5);
				case Tile.poison_water: return poison.lerp(water_fg, 0.125);
				case Tile.shallow_water: return water_fg;
				case Tile.frozen_water: return ice;
				case Tile.portal: return Color.hsv(Math.random() * 360, 50, 90);
				case Tile.grass: return Color.integer(grassForegroundBitmap.getPixel(x, y));
				case Tile.grass_fire: return fire.lerp(Color.integer(grassForegroundBitmap.getPixel(x, y)), 0.33);
				case Tile.tree: return Color.integer(treeBitmap.getPixel(x, y));
				case Tile.tree_fire_3: return fire.lerp(Color.integer(treeBitmap.getPixel(x, y)), 0.1);
				case Tile.tree_fire_2: return fire.lerp(Color.integer(treeBitmap.getPixel(x, y)), 0.3);
				case Tile.tree_fire_1: return fire.lerp(Color.integer(treeBitmap.getPixel(x, y)), 0.5);
				case Tile.stone_door_opened: return metal_fg;
				case Tile.stone_door_closed: return metal_fg;
				case Tile.wood_door_opened: return wood_fg;
				case Tile.wood_door_closed: return wood_fg;
				case Tile.door_opened_fire: return fire.lerp(wood_bg, 0.2);
				case Tile.door_closed_fire: return fire.lerp(wood_bg, 0.2);
				case Tile.wall: return stone_fg;
				case Tile.bars_h:
				case Tile.bars_v: return metal_fg;
				case Tile.moving_wall: return white.lerp(stone_fg, 0.50);
				case Tile.floor_dark: return tile_3;
				case Tile.floor_light: return tile_4;
				case Tile.mystic_floor_dark: return magic.lerp(black, 0.33);
				case Tile.mystic_floor_light: return magic.lerp(black, 0.33);
				case Tile.ice_tower:
				case Tile.ice_tower_1:
				case Tile.ice_tower_2:
				case Tile.ice_tower_3:
				case Tile.ice_tower_4:
				case Tile.ice_tower_5:
				case Tile.ice_tower_6:
					return ice;
				case Tile.tower:
				case Tile.tower_1:
				case Tile.tower_2:
				case Tile.tower_3:
				case Tile.tower_4:
				case Tile.tower_5:
				case Tile.tower_6:
					return metal_fg;
				case Tile.poison_tower:
				case Tile.poison_tower_1:
				case Tile.poison_tower_2:
				case Tile.poison_tower_3:
				case Tile.poison_tower_4:
				case Tile.poison_tower_5:
				case Tile.poison_tower_6:
					return poison;
				case Tile.fire_tower:
				case Tile.fire_tower_1:
				case Tile.fire_tower_2:
				case Tile.fire_tower_3:
				case Tile.fire_tower_4:
				case Tile.fire_tower_5:
				case Tile.fire_tower_6:
					return fire;
				case Tile.dirt: return ash.lerp(Color.integer(grassForegroundBitmap.getPixel(x, y)), 0.25);
				case Tile.burnt_ground: return ash.lerp(Color.integer(grassForegroundBitmap.getPixel(x, y)), 0.5);
				case Tile.track_light_ns:
				case Tile.track_dark_ns:
				case Tile.track_light_we:
				case Tile.track_dark_we:
				case Tile.track_light_nw:
				case Tile.track_dark_nw:
				case Tile.track_light_ne:
				case Tile.track_dark_ne:
				case Tile.track_light_sw:
				case Tile.track_dark_sw:
				case Tile.track_light_se:
				case Tile.track_dark_se:
					return Color.integer(0x333333);
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
				case Tile.magma: return Color.hsv(20 + Math.random() * 10, 80 + Math.random() * 10, 30 + Math.random() * 10);
				case Tile.golden_statue: return stone_bg;
				case Tile.ice_trap:
				case Tile.poison_trap:
				case Tile.fire_trap: return tile_2;
				case Tile.healingFog: return Color.hsv(300, 33, 33);
				case Tile.poisonFog: return poison;
				case Tile.poison_water: return poison.lerp(water_bg, 0.125);
				case Tile.shallow_water: return water_bg;
				case Tile.frozen_water: return water_fg;
				case Tile.portal: return Color.hsv(Math.random() * 360, 50, 90);
				case Tile.grass: return Color.integer(grassBackgroundBitmap.getPixel(x, y));
				case Tile.grass_fire: return fire.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.33);
				case Tile.tree: return Color.integer(grassBackgroundBitmap.getPixel(x, y));
				case Tile.tree_fire_3: return fire.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.1);
				case Tile.tree_fire_2: return fire.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.3);
				case Tile.tree_fire_1: return fire.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.5);
				case Tile.stone_door_opened: return tile_4;
				case Tile.stone_door_closed: return tile_4;
				case Tile.wood_door_opened: return wood_bg;
				case Tile.wood_door_closed: return wood_bg;
				case Tile.door_opened_fire: return fire.lerp(wood_bg, 0.1);
				case Tile.door_closed_fire: return fire.lerp(wood_bg, 0.1);
				case Tile.wall: return stone_bg;
				case Tile.bars_h:
				case Tile.bars_v: return tile_2;
				case Tile.moving_wall: return white.lerp(stone_bg, 0.25);
				case Tile.floor_dark: return tile_1;
				case Tile.floor_light: return tile_2;
				case Tile.mystic_floor_dark: return tile_1;
				case Tile.mystic_floor_light: return tile_2;
				case Tile.ice_tower:
				case Tile.ice_tower_1:
				case Tile.ice_tower_2:
				case Tile.ice_tower_3:
				case Tile.ice_tower_4:
				case Tile.ice_tower_5:
				case Tile.ice_tower_6:
				case Tile.fire_tower:
				case Tile.fire_tower_1:
				case Tile.fire_tower_2:
				case Tile.fire_tower_3:
				case Tile.fire_tower_4:
				case Tile.fire_tower_5:
				case Tile.fire_tower_6:
				case Tile.poison_tower:
				case Tile.poison_tower_1:
				case Tile.poison_tower_2:
				case Tile.poison_tower_3:
				case Tile.poison_tower_4:
				case Tile.poison_tower_5:
				case Tile.poison_tower_6:
				case Tile.tower:
				case Tile.tower_1:
				case Tile.tower_2:
				case Tile.tower_3:
				case Tile.tower_4:
				case Tile.tower_5:
				case Tile.tower_6:
					return stone_fg;
				case Tile.dirt: return ash.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.25);
				case Tile.burnt_ground: return ash.lerp(Color.integer(grassBackgroundBitmap.getPixel(x, y)), 0.5);
				case Tile.track_light_ns: return tile_2;
				case Tile.track_dark_ns: return tile_1;
				case Tile.track_light_we: return tile_2;
				case Tile.track_dark_we: return tile_1;
				case Tile.track_light_nw: return tile_2;
				case Tile.track_dark_nw: return tile_1;
				case Tile.track_light_ne: return tile_2;
				case Tile.track_dark_ne: return tile_1;
				case Tile.track_light_sw: return tile_2;
				case Tile.track_dark_sw: return tile_1;
				case Tile.track_light_se: return tile_2;
				case Tile.track_dark_se: return tile_1;
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
		
		private function drawArrow(terminal:AsciiPanel, effect:Arrow):Boolean 
		{
			if (!canSee(effect.x, effect.y))
				return false;
			
			var fgc:Color = payloadColor(effect.payload);
			
			terminal.write(arrowTile(effect.direction), effect.x, effect.y, fgc.toInt(), terminal.getBackgroundColor(effect.x, effect.y));
			
			if (!(effect.payload is Pierce))
				addLight(terminal, effect.x, effect.y, fgc, 2);
				
			return true;
		}
		
		private function drawExplosion(terminal:AsciiPanel, effect:Explosion):Boolean 
		{
			var color:Color = payloadColor(effect.payload);
			var didDrawAny:Boolean = false;
			
			for each (var t:Point in effect.tiles)
			{
				if (!canSee(t.x, t.y))
					continue;
			
				didDrawAny = true;
				
				terminal.write(
					terminal.getCharacter(t.x, t.y),
					t.x, 
					t.y, 
					color.lerp(Color.integer(terminal.getForegroundColor(t.x, t.y)), 0.5).toInt(), 
					color.lerp(Color.integer(terminal.getBackgroundColor(t.x, t.y)), 0.5).toInt());
			}
			for each (var t2:Point in effect.frontiers)
			{
				if (!canSee(t2.x, t2.y))
					continue;
			
				didDrawAny = true;
				
				terminal.write(
					terminal.getCharacter(t2.x, t2.y),
					t2.x, 
					t2.y, 
					color.lerp(Color.integer(terminal.getForegroundColor(t2.x, t2.y)), 0.25).toInt(), 
					color.lerp(Color.integer(terminal.getBackgroundColor(t2.x, t2.y)), 0.25).toInt());
			}
			
			return didDrawAny;s
		}
		
		private function drawMagicMissileProjectile(terminal:AsciiPanel, effect:MagicMissileProjectile):Boolean 
		{
			if (!canSee(effect.x, effect.y))
				return false;
				
			terminal.write(
				arrowTile(effect.direction), 
				effect.x, 
				effect.y, 
				magic.toInt(), 
				terminal.getBackgroundColor(effect.x, effect.y));
				
			addLight(terminal, effect.x, effect.y, magic, 2);
			
			return true;
		}
	}
}