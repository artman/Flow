package com.flow.managers {
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	public class TextFormatManager {
		
		private static var fontDictionary:Object;
		private static var textFormatDictionary:Object;
		
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
				if(ret) {
					return ret;
				} else {
					for each(var tf:Object in textFormatDictionary) {
						return tf as TextFormat;
					}
				}
			}
			return null;
		}
	}
}