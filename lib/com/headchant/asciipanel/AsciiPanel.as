package com.headchant.asciipanel {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	/**
	 * @author Tilmann Hars
	 * heavly inspired by the java AsciiPanel by trystan: trystans.blogspot.com
	 */
	public class AsciiPanel extends Sprite {
		[Embed(source="cp437_9x16.png", mimeType = "image/png")]
		public static const codePage437_9x16:Class;
		
		[Embed(source = "cp437_8x8.png", mimeType = "image/png")]
		public static const codePage437_8x8:Class;
		
		private var glyphs : Array;
		private var fontBitmapData : BitmapData;
		private var widthInCharacters : int;
		private var heightInCharacters : int;
		private var screen : BitmapData;
		private var chars : Array;
		private var fontBitmap : Bitmap;
		private var charHeight : int;
		private var charWidth : int;
		private var screenBitmap : Bitmap;
		private var foregroundColor : Array;
		private var backgroundColor : Array;
		private var originalForegroundColor : uint = AsciiPanel.DARKWHITE;
		private var originalBackgroundColor : uint = AsciiPanel.BLACK;
		
		public static var WHITE : uint = rgbaColor(255,255,255);
		public static var BLACK : uint = rgbaColor(0,0,0);
		public static var RED : uint = rgbaColor(255,0,0);
		public static var BLUE : uint = rgbaColor(0,0,255);		
		public static var GREEN : uint = rgbaColor(0,255,0);
		public static var YELLOW : uint = rgbaColor(128, 128, 0);
		public static var GREY : uint = rgbaColor(128, 128, 128);
		public static var DARKWHITE : uint = rgbaColor(192, 192, 192);
		
		// more exotic colors
		public static var DODGERBLUE : uint = rgbaColor(30, 144, 255);
		private var oldchars : Array;
		private var oldbackgroundColor : Array;
		private var oldforegroundColor : Array;
		
		/**
		 * The default color to use when the foreground color is not specified.
		 */
		public var defaultForegroundColor : uint = DARKWHITE;
		
		/**
		 * The default color to use when the background color is not specified.
		 */
		public var defaultBackgroundColor : uint = BLACK;
		
		/**
		 * Where the last text ended and the next text will continue from if a position isn't specified.
		 */
		public var currentPosition : Point = new Point(0, 0);;
		
		public function getWidthInCharacters() : int { return widthInCharacters; }
		public function getHeightInCharacters() : int { return heightInCharacters; }
		
		public function AsciiPanel(widthInCharacters:int = 80, heightInCharacters:int = 24) {	
			this.widthInCharacters = widthInCharacters;
			this.heightInCharacters = heightInCharacters;
			
			useRasterFont(codePage437_9x16, 9, 16);
		}
		
		/**
		 * Use a custom bitmap font such as AsciiPanel.codePage437_8x8 or AsciiPanel.codePage437_9x16.
		 * @param	fontImage	The top left character is 0, the bottom right is 255.
		 * @param	charWidth	The width, in pixels, of each character.
		 * @param	charHeight	The height, in pixels, of each character.
		 */
		public function useRasterFont(fontImage:Class, charWidth:int, charHeight:int):void {
			this.fontBitmap = new fontImage() as Bitmap;
			this.fontBitmapData = fontBitmap.bitmapData;
			this.charWidth = charWidth;
			this.charHeight = charHeight;
			
			var imageWidthInCharacters:int = fontBitmapData.width / charWidth;
			
			this.glyphs = new Array();
			for (var i : int = 0; i < 256; i++) {
				var sx:int = (i % imageWidthInCharacters) * charWidth;
				var sy:int = int(i / imageWidthInCharacters) * charHeight;
				glyphs[i] = new BitmapData(charWidth, charHeight);
				(glyphs[i] as BitmapData).copyPixels(fontBitmapData, new Rectangle(sx,sy,charWidth, charHeight), new Point(0,0));
			}
			
			width = charWidth*widthInCharacters;
			height = charHeight * heightInCharacters;
			
			screen = new BitmapData(charWidth*widthInCharacters, charHeight*heightInCharacters,false,0x000000);
			chars = new Array();
			oldchars = new Array();
			foregroundColor = new Array();
			backgroundColor = new Array();
			oldforegroundColor = new Array();
			oldbackgroundColor = new Array();
			
			for (i = 0; i < widthInCharacters; i++) {
				chars[i] = [];
				oldchars[i] = [];
				foregroundColor[i] = [];
				backgroundColor[i] = [];
				oldforegroundColor[i] = [];
				oldbackgroundColor[i] = [];
				for (var j : int = 0; j < heightInCharacters; j++) {
					chars[i][j] = 0;
					oldchars[i][j] = -1;
					foregroundColor[i][j] = originalForegroundColor;
					backgroundColor[i][j] = originalBackgroundColor;
					oldforegroundColor[i][j] = originalForegroundColor;
					oldbackgroundColor[i][j] = originalBackgroundColor;
				}
			}
			
			if (screenBitmap != null)
				removeChild(screenBitmap);
			
			screenBitmap = new Bitmap(screen);
			screenBitmap.smoothing = false;
			addChild(screenBitmap);
			scaleX = 1;
			scaleY = 1;
			paint();
		}
		
		/**
		 * Applies all updates that have happened since the last call to paint().
		 */
		public function paint():void {
			screen.lock();
			
			var sourceRect:Rectangle = new Rectangle(0, 0, charWidth, charHeight);
					
			for (var i:int = 0; i < widthInCharacters; i++) {
				for (var j : int = 0; j < heightInCharacters; j++) {
					if (chars[i][j] == oldchars[i][j] 
						&& foregroundColor[i][j] == oldforegroundColor[i][j]
						&& backgroundColor[i][j] == oldbackgroundColor[i][j])
						continue;
					if (chars[i][j] == null)
						continue;
						
					var bitmapdata:BitmapData = (glyphs[chars[i][j]] as BitmapData);
					var destPoint:Point = new Point(i * charWidth, j * charHeight);
					
					if(foregroundColor[i][j] != originalForegroundColor || backgroundColor[i][j] != originalBackgroundColor)
					{
						var tile:Vector.<uint> = bitmapdata.getVector(sourceRect); 
						var tileLength:uint = tile.length;
					
						var destRect:Rectangle = new Rectangle(destPoint.x, destPoint.y, charWidth, charHeight);
					
						for(var pixel:uint = 0; pixel < tileLength; pixel++)
						{
							if(tile[pixel] == originalBackgroundColor)
							{
								if(backgroundColor[i][j] != originalBackgroundColor)
								{
									tile[pixel] = backgroundColor[i][j];
								}
							}
							else if(foregroundColor[i][j] != originalForegroundColor)
							{
								tile[pixel] = foregroundColor[i][j];
							}
						}
						screen.setVector(destRect, tile);
					}
					else
					{
						screen.copyPixels(bitmapdata, sourceRect, destPoint);
					}
				}
			}
			oldchars = copy(chars);
			oldbackgroundColor = copy(backgroundColor);
			oldforegroundColor = copy(foregroundColor);
			screen.unlock();
		}
		
		private function copy(itemToCopy:Array):Array{
		    var newArray:Array = new Array();
		    for(var i:int = 0; i < (itemToCopy as Array).length; i++)
		        newArray[i] = (itemToCopy[i] as Array).slice();
		    return newArray;
		}
		
		public static function rgbaColor(r:int, g:int, b:int, a:int = 255):uint{
			return (a << 24) | (r << 16) | (g << 8) | b;
		}
		
		/**
		 * Write some text at the specified location.
		 * @param	string	The text to write.
		 * @param	x		Must be a uint or null. Will continue from currentPosition.x if left null.
		 * @param	y		Must be a uint or null. Will continue from currentPosition.y if left null.
		 * @param	fgcolor	The foreground color. Must be a uint or null. Will use defaultForegroundColor if left null.
		 * @param	bgcolor	The background color. Must be a uint or null. Will use defaultBackgroundColor if left null.
		 */
		public function write(string:String, x:* = null, y:* = null, fgcolor:* = null, bgcolor:* = null):void {
			if (string == null)
				throw Error("string must not be null");
			
			if (x == null)
				x = currentPosition.x;
				
			if (y == null)
				y = currentPosition.y;
				
			if (fgcolor == null)
				fgcolor = defaultForegroundColor;
			
			if (bgcolor == null)
				bgcolor = defaultBackgroundColor;
				
			for (var i : int = 0; i < string.length; i++) {
				foregroundColor[x][y] = fgcolor;
				backgroundColor[x][y] = bgcolor;	
				chars[x][y] = string.charCodeAt(i);
				x++;
				currentPosition.x = x;
				currentPosition.y = y;
			}
		}
		
		/**
		 * Write some text in the center of a specified row.
		 * @param	string	The text to write.
		 * @param	y
		 * @param	fgcolor	The foreground color. Must be a uint or null. Will use defaultForegroundColor if left null.
		 * @param	bgcolor	The background color. Must be a uint or null. Will use defaultBackgroundColor if left null.
		 */
		public function writeCenter(string:String, y:int, fgcolor:* = null, bgcolor:* = null):void{
			var x:int = (widthInCharacters - string.length) / 2;
			write(string, x, y, fgcolor, bgcolor);
		}
		
		/**
		 * Clear the panel.
		 * @param	char
		 * @param	fgcolor	The foreground color. Must be a uint or null. Will use defaultForegroundColor if left null.
		 * @param	bgcolor	The background color. Must be a uint or null. Will use defaultBackgroundColor if left null.
		 */
		public function clear(char:String = " ", fgcolor:* = null, bgcolor:* = null):void{
			if (fgcolor == null)
				fgcolor = defaultForegroundColor;
				
			if (bgcolor == null)
				bgcolor = defaultBackgroundColor;
				
			for (var i:int = 0; i < widthInCharacters; i++) {
				for (var j : int = 0; j < heightInCharacters; j++) {
					chars[i][j] = char.charCodeAt(0);
					foregroundColor[i][j] = fgcolor;
					backgroundColor[i][j] = bgcolor;
				}
			}
		}
	}
}
