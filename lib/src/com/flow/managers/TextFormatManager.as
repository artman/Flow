package com.flow.managers {
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class TextFormatManager {
		
		private static var fontDictionary:Object;
		private static var textFormatDictionary:Object;
		private static var fonts:Object;
		
		public static function registerFont(fontName:String, fontClass:Class):void {
			if(!fontDictionary) {
				fontDictionary = {};
			}
			var font:Font = new fontClass();
			Font.registerFont(fontClass);
			fontDictionary[fontName] = font.fontName;
		}
		
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