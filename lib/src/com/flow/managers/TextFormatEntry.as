package com.flow.managers {
	import flash.text.TextFormat;

	public class TextFormatEntry {
		
		public var textFormat:TextFormat;
		public var filters:Array;
		
		public function TextFormatEntry(textFormat:TextFormat, filters:Array = null) {
			this.textFormat = textFormat;
			this.filters = filters;
		}
	}
}