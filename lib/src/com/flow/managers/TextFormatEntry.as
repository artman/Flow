package com.flow.managers {
	import flash.text.Font;
	import flash.text.TextFormat;

	public class TextFormatEntry {
		
		public var textFormat:TextFormat;
		public var fallback:String;
		public var filters:Array;
		
		public function TextFormatEntry(textFormat:TextFormat, fallback:Array = null, filters:Array = null) {
			this.textFormat = textFormat;
			this.filters = filters;
			if(fallback) {
				for(var i:int = 0; i<fallback.length; i++) {
					var font:Font = TextFormatManager.getDeviceFont(fallback[i]);
					if(font) {
						this.fallback = fallback[i];
						break;
					}
				}
			}
		}
		
		public function getFallback():String {
			return fallback ? fallback : TextFormatManager.defaultFallbackFont;
		}
	}
}