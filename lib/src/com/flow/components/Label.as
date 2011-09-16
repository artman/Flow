
package com.flow.components {
	
	import com.flow.components.supportClasses.PaddableComponent;
	import com.flow.managers.TextFormatManager;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	[DefaultProperty("htmlText")]
	public class Label extends PaddableComponent {
		
		private var _text:String = "";
		private var _textField:TextField;
		private var _align:String;
		private var _verticalAlign:String = "middle";
		private var _size:int;
		private var _color:int;
		private var hasColor:Boolean = false;
		private var _ellipsis:Boolean = false;
		private var _textTransform:String = "";
		private var _multiline:Boolean = false;
		private var _textFormat:String = "normal";
		private var _editable:Boolean;
		
		private var isHTML:Boolean = false;		
		
		public function Label() {
			super();
			mouseEnabled = false;
			mouseChildren = false;
			_textField = new TextField();
			_textField.selectable = false;
			_textField.embedFonts = true;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			multiline = false;
			addChild(_textField);
		}
		
		[Inspectable(enumeration="none,uppercase,lowercase", defaultValue="none")]
		public function get textTransform():String {
			return _textTransform;
		}
		public function set textTransform(value:String):void {
			if(value != _textTransform) {
				_textTransform = value;
				invalidateProperties();
			}
		}
		
		public function get text():String {
			return _text;
		}
		public function set text(value:String):void {
			if(value != _text) {
				isHTML = false;
				_text = value ? value : "";
				invalidateProperties(true);
			}
		}
		
		public function get editable():Boolean {
			return _editable;
		}
		public function set editable(value:Boolean):void {
			if(value != _editable) {
				_editable = value;
				if(_editable) {
					_textField.type = TextFieldType.INPUT;
				} else {
					_textField.type = TextFieldType.DYNAMIC;
				}
				mouseEnabled = mouseChildren = _textField.selectable = editable;
			}
		}
		
		public function get htmlText():String {
			return _text;
		}
		public function set htmlText(value:String):void {
			if(value != _text) {
				isHTML = true;
				_text = value ? value : "";
				invalidateProperties(true);
			}
		}
		
		[Inspectable(enumeration="left,center,right", defaultValue="left")]
		public function get align():String {
			return _align;
		}
		public function set align(value:String):void {
			if(value != _align) {
				_align = value;
				invalidateProperties();
			}
		}
		
		[Inspectable(enumeration="top,middle,bottom", defaultValue="middle")]
		public function get verticalAlign():String {
			return _verticalAlign;
		}
		public function set verticalAlign(value:String):void {
			if(value != _verticalAlign) {
				_verticalAlign = value;
				invalidateProperties();
			}
		}
		
		public function get ellipsis():Boolean {
			return _ellipsis;
		}
		public function set ellipsis(value:Boolean):void {
			if(value != _ellipsis) {
				_ellipsis = value;
				invalidateProperties();
			}
		}
		
		public function get multiline():Boolean {
			return _multiline;
		}
		public function set multiline(value:Boolean):void {
			if(value != _multiline) {
				_multiline = value;
				invalidateProperties();
			}
		}
		
		public function get color():int {
			return _color;
		}
		public function set color(value:int):void {
			_color = value;
			hasColor = true; 
			invalidateProperties();
		}
		
		public function get size():int {
			return _size;
		}
		public function set size(value:int):void {
			_size = value;
			invalidateProperties();
		}
		
		public function get textFormat():String {
			return _textFormat;
		}
		public function set textFormat(value:String):void {
			if(value != _textFormat) {
				_textFormat = value;
				invalidateProperties();
			}
		}
		
		public function get textField():TextField {
			return _textField;
		}
		
		override public function validateProperties():void {
			var def:TextFormat = TextFormatManager.getTextFormat(_textFormat);
			if(!def) {
				_textField.embedFonts = false;
				def = new TextFormat();
			} else {
				_textField.embedFonts = true;
			}
			if(_size) {
				def.size = _size;
			}
			if(hasColor) {
				def.color = _color;
			}
			if(_align) {
				def.align = _align;
			}
			_textField.defaultTextFormat = def;
			_textField.multiline = _multiline;
			_textField.wordWrap = _multiline;
			if(isHTML) {
				_textField.htmlText = transformedText;
			} else {
				_textField.text = transformedText;
			}
			
			if(TextFormatManager.hasEmbeddedFont(def.font)) {
				_textField.embedFonts = true;
			} else {
				_textField.embedFonts = false;
			}
		}
		
		private function get transformedText():String {
			if(_textTransform == "uppercase") {
				return _text.toUpperCase();
			} else if(_textTransform == "lowecase") {
				return _text.toLowerCase();
			}
			return _text;
		}
		
		override protected function measureWithPadding(horizontal:int, vertical:int):void {
			if(hasExplicitWidth) {
				_textField.width = _w.value - horizontal;
			}
			if(isHTML) {
				_textField.htmlText = transformedText;
			} else {
				_textField.text = transformedText;
			}
			measuredWidth = Math.ceil(_textField.textWidth + horizontal + 4); // 4px gutter
			measuredHeight = Math.ceil(_textField.textHeight + vertical + 6); // 4px gutter + 2px top margin
		}
		
		override protected function drawWithPadding(offsetX:int, offsetY:int, width:int, height:int):void {
			super.drawWithPadding(offsetX, offsetY, width, height);
			_textField.x = offsetX;
			_textField.autoSize = "none";
			_textField.width = width+1;
			if(align == "center") {
				_textField.width = Math.floor(_textField.width/2)*2;
			}
			_textField.height = height-2;
			
			if(_verticalAlign == "top") {
				_textField.y = offsetY+2;
			} else if(_verticalAlign == "middle") {
				_textField.y = offsetY + Math.round((height - (_textField.textHeight+2))/2);
			} else {
				_textField.y = offsetY + Math.round(height - (_textField.textHeight+4));
			}
			if(_ellipsis) {
				var orgi:String = _text;
				while(_textField.textWidth+4 > _textField.width && orgi.length) {
					orgi = orgi.substring(0,orgi.length-1);
					_textField.text = orgi + "...";
				}
			}
		}
	}
}