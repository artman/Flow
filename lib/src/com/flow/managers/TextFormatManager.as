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
		private static var fonts:Object;
		
		/**
		 * Registers a font. This can be used to name the fonts used in your application. 
		 * @param The name to give the font
		 * @param The font class to associate with the give name.
		 * 
		 */		
		public static function registerFont(fontName:String, fontClass:Class):void {
			if(!fontDictionary) {
				fontDictionary = {};
			}
			var font:Font = new fontClass();
			Font.registerFont(fontClass);
			fontDictionary[fontName] = font.fontName;
		}
		
		/**
		 * Registeres a text format that can be used in various Flow components. 
		 * @param The name to give this text format
		 * @param A TextFormat instance to associate with the name. The text format's font-property can reference fonts that have been registered
		 * using the registerFont method.
		 * @see #registerFont
		 */		
		public static function registerTextFormat(name:String, textFormat:TextFormat):void {
			if(!textFormatDictionary) {
				textFormatDictionary = {};
			}
			if(textFormat.font) {
				if(fontDictionary && fontDictionary[textFormat.font]) {
					textFormat.font = fontDictionary[textFormat.font];
				}
			}
			textFormatDictionary[name] = textFormat;
		}
		
		/**
		 * Retreives a text format. 
		 * @param The name of the text format to retreive
		 * @return The found text format or a default text format if no registered text format with the given name was found.
		 */		
		public static function getTextFormat(name:String):TextFormat {
			if(textFormatDictionary) {
				var ret:TextFormat = textFormatDictionary[name];
				if(!ret) {
					for each(var tf:Object in textFormatDictionary) {
						ret = tf as TextFormat;
						break;
					}
				}
			}
			if(ret) {
				return new TextFormat(ret.font, ret.size, ret.color, ret.bold, ret.italic, ret.underline, ret.url, ret.target, ret.align, ret.leftMargin, ret.rightMargin, ret.indent, ret.leading);
			}
			return new TextFormat("Arial", 11);
		}
		
		/**
		 * Checks if a font with an optional style has been embedded in the SWF.
		 * @param The name of the font.
		 * @param An optional style of the font.
		 * @return True, if the font has been embedded, false otherwise.
		 */		
		public static function hasEmbeddedFont(fontName:String, fontStyle:String = null):Boolean {
			if(!fonts) {
				fonts = {};
				var fontArray:Array = Font.enumerateFonts(false);
				for(var i:int; i<fontArray.length; i++) {
					if(!fonts[fontArray[i].fontName]) {
						fonts[fontArray[i].fontName] = {}
					}
					fonts[fontArray[i].fontName][fontArray[i].fontStyle] = true;
				}
			}
			if(!fontStyle) {
				return fonts[fontName] ? true : false;
			} 
			return fonts[fontName][fontStyle] ? true : false;
		}
	}
}