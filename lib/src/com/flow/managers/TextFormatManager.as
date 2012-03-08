/**
 * Copyright (c) 2011 Tuomas Artman, http://artman.fi
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.flow.managers {
	import flash.text.Font;
	import flash.text.TextFormat;
	
	/**
	 * A collection of static methods to register fonts and text formats used by various Flow components. 
	 */	
	public class TextFormatManager {
		
		private static var fontDictionary:Object;
		private static var textFormatDictionary:Object;
		private static var fontLookup:Object;
		private static var fonts:Object;
		private static var deviceFonts:Object;
		
		/**
		 * The default fallback font to use in case none was provided when registering a new text format style. 
		 */		
		public static var defaultFallbackFont:String = "Arial";
		
		/**
		 * Registers a font. This can be used to name the fonts used in your application. 
		 * @param The name to give the font
		 * @param The font class to associate with the give name.
		 * 
		 */		
		public static function registerFont(fontName:String, fontClass:Class):void {
			fonts = {};
			if(!fontDictionary) {
				fontDictionary = {};
			}
			var font:Font = new fontClass();
			Font.registerFont(fontClass);
			fontDictionary[fontName] = font.fontName;
			fonts[fontName] = fontClass;
		}
		
		/**
		 * Registeres the default text format. The default text format is used whenever a textFormat style used by a component is not found. If you
		 * don't provide a default text format Flow will use Arial at size 11 for all text styles that haven't been defined.
		 * @param A TextFormat instance to associate with the name. The text format's font-property can reference fonts that have been registered
		 * using the registerFont method.
		 * @param An array of font names used as fallback in case no embedded font is found.
		 * @param An array of filter to be applied on the text rendered by components usinf the textFormat style.
		 * @see #registerFont
		 */		
		public static function registerDefaultTextFormat(textFormat:TextFormat, fallback:Array = null, filters:Array = null):void {
			registerTextFormat("_defaultFormat", textFormat, fallback, filters);
		}
		
		/**
		 * Registeres a text format that can be used in various Flow components. 
		 * @param The name to give this text format
		 * @param A TextFormat instance to associate with the name. The text format's font-property can reference fonts that have been registered
		 * using the registerFont method.
		 * @param An array of font names used as fallback in case no embeded font is found.
		 * @param An array of filter to be applied on the text rendered by components usinf the textFormat style.
		 * @see #registerFont
		 */		
		public static function registerTextFormat(name:String, textFormat:TextFormat, fallback:Array = null, filters:Array = null):void {
			if(!textFormatDictionary) {
				textFormatDictionary = {};
			}
			if(textFormat.font) {
				if(fontDictionary && fontDictionary[textFormat.font]) {
					textFormat.font = fontDictionary[textFormat.font];
				}
			}
			textFormatDictionary[name] = new TextFormatEntry(textFormat, filters);
		}
		
		/**
		 * Retreives a text format. 
		 * @param The name of the text format to retreive
		 * @return The found text format or a default text format if no registered text format with the given name was found.
		 */		
		public static function getTextFormat(name:String):TextFormatEntry {
			if(textFormatDictionary) {
				var ret:TextFormatEntry = textFormatDictionary[name];
				if(!ret) {
					ret = textFormatDictionary["_defaultFormat"];
					if(!ret) {
						registerDefaultTextFormat(new TextFormat("Arial", 11, 0, false), ["Verdana"]);
						ret = textFormatDictionary["_defaultFormat"];
					}
				}
			}

			var format:TextFormat = ret.textFormat;
			return new TextFormatEntry(new TextFormat(format.font, format.size, format.color, format.bold, format.italic, format.underline, 
				format.url, format.target, format.align, format.leftMargin, format.rightMargin, format.indent, format.leading), 
				[ret.fallback], ret.filters);
		}
		
		/**
		 * Checks if a font with an optional style has been embedded in the SWF.
		 * @param The name of the font.
		 * @param An optional style of the font.
		 * @return True, if the font has been embedded, false otherwise.
		 */		
		public static function hasEmbeddedFont(fontName:String, fontStyle:String = "regular"):Boolean {
			var font:Font = getEmbeddedFont(fontName, fontStyle);
			return font ? true: false;
		}
		
		/**
		 * Retreives a embedded font with an optional style.
		 * @param The name of the font.
		 * @param An optional style of the font.
		 * @return The found font object.
		 */		
		public static function getEmbeddedFont(fontName:String, fontStyle:String = "regular"):Font {
			if(!fontLookup) {
				fontLookup = {};
				var fontArray:Array = Font.enumerateFonts(false);
				for(var i:int; i<fontArray.length; i++) {
					if(!fontLookup[fontArray[i].fontName]) {
						fontLookup[fontArray[i].fontName] = {}
					}
					fontLookup[fontArray[i].fontName][fontArray[i].fontStyle] = fontArray[i];
				}
			}
			return fontLookup[fontName] ? fontLookup[fontName][fontStyle] : null;
		}
		
		public static function getDeviceFont(fontName:String, fontStyle:String = "regular"):Font {
			if(!deviceFonts) {
				deviceFonts = {};
				var fontArray:Array = Font.enumerateFonts(true);
				for(var i:int; i<fontArray.length; i++) {
					if(!deviceFonts[fontArray[i].fontName]) {
						deviceFonts[fontArray[i].fontName] = {}
					}
					deviceFonts[fontArray[i].fontName][fontArray[i].fontStyle] = fontArray[i];
				}
			}
			return deviceFonts[fontName] ? deviceFonts[fontName][fontStyle] : null;
		}
		
		public static function canRenderText(textFormat:TextFormat, text:String):Boolean {
			var font:Font = getEmbeddedFont(textFormat.font);
			return font ? font.hasGlyphs(text) : false;
		}
	}
}