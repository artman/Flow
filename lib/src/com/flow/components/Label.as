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

package com.flow.components {
	
	import com.flow.components.supportClasses.PaddableComponent;
	import com.flow.managers.TextFormatManager;
	
	import flash.display.DisplayObject;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	/**
	 * A generic class for displaying text with an optional icon.
	 */	
	[DefaultProperty("htmlText")]
	public class Label extends PaddableComponent {
		
		/** @private */
		protected var _text:String = "";
		/** @private */
		protected var _textField:TextField;
		/** @private */
		protected var _align:String;
		/** @private */
		protected var _verticalAlign:String = "middle";
		/** @private */
		protected var _size:int;
		/** @private */
		protected var _color:int;
		/** @private */
		protected var hasColor:Boolean = false;
		/** @private */
		protected var _ellipsis:Boolean = false;
		/** @private */
		protected var _textTransform:String = "";
		/** @private */
		protected var _multiline:Boolean = false;
		/** @private */
		protected var _textFormat:String = "normal";
		/** @private */
		protected var _editable:Boolean;
		/** @private */
		protected var _icon:DisplayObject;
		/** @private */
		protected var _iconPadding:Number = 5;
		/** @private */
		protected var _iconPlacement:String = "left";
		/** @private */
		protected var isHTML:Boolean = false;
		/** @private */
		private var ellipsisText:String;
		
		/**
		 * Constructor.
		 */		
		public function Label() {
			super();
			mouseChildren = false;
			_textField = new TextField();
			_textField.selectable = false;
			_textField.embedFonts = true;
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			multiline = false;
			addChild(_textField);
		}
		
		/**
		 * A text transformation to be applied to the text that is displayed. Supported values are none, uppercase and lowercase. 
		 */		
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
		
		/** The text to display. */		
		[Bindable]
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
		
		/** Whether the label is user editable or not. */
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
		
		/** Wheher the label should be displayed as HTML text or plain text. */
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
		
		/** The alignment of the text. Supported values are left, right and center. */
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
		
		/** How to vertically align the text. Supported values are top, middle and bottom. */
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
		
		/** If the text does not fit into the dimensions of the label and ellipisis is set to true, the overflow will be cut of and three dots
		 * (...) are added to the end. */		
		public function get ellipsis():Boolean {
			return _ellipsis;
		}
		public function set ellipsis(value:Boolean):void {
			if(value != _ellipsis) {
				_ellipsis = value;
				invalidateProperties();
			}
		}
		
		/** Defines whether the label can have multiple lines */
		public function get multiline():Boolean {
			return _multiline;
		}
		public function set multiline(value:Boolean):void {
			if(value != _multiline) {
				_multiline = value;
				invalidateProperties();
			}
		}
		
		/** The color of the text */
		[Animateable(type='color')]
		public function get color():int {
			return _color;
		}
		public function set color(value:int):void {
			_color = value;
			hasColor = true; 
			invalidateProperties();
		}
		
		[Animateable]
		/** The pixel size of the font */
		public function get size():int {
			return _size;
		}
		public function set size(value:int):void {
			_size = value;
			invalidateProperties();
		}
		
		/** 
		 * The text format to use on this label. You define new textformats using the TextFormatManager. 
		 * @see TextFormatManager
		 */
		public function get textFormat():String {
			return _textFormat;
		}
		public function set textFormat(value:String):void {
			if(value != _textFormat) {
				_textFormat = value;
				invalidateProperties();
			}
		}
		
		/** A icon the be displayed on the label */
		public function get icon():DisplayObject {
			return _icon;
		}
		public function set icon(value:DisplayObject):void {
			if(value != _icon) {
				if(_icon) {
					removeChild(_icon);
				}
				_icon = value;
				if(_icon) {
					_icon.visible = false; // Fixme: For some reason layout is deffered by one frame when setting this in a state change.
					addChild(_icon);
				}	
				invalidateLayout();
				invalidate();
			}
		}
		
		/** The padding between an icon and the text */
		public function get iconPadding():Number {
			return _iconPadding;
		}
		public function set iconPadding(value:Number):void {
			if(value != _iconPadding) {
				_iconPadding = value;
				invalidateLayout();
				invalidate();
			}
		}
		
		/** The placement of the icon. Values can be either left or right */
		[Inspectable(enumeration="left,right", defaultValue="left")]
		public function get iconPlacement():String {
			return _iconPlacement;
		}
		public function set iconPlacement(value:String):void {
			if(value != _iconPlacement) {
				_iconPlacement = value;
				invalidate();
			}
		}
		
		/** A reference to the TextField instance used by the label */
		public function get textField():TextField {
			return _textField;
		}
		
		/** @private */
		override public function validateProperties():void {
			super.validateProperties();
			var def:TextFormat = TextFormatManager.getTextFormat(_textFormat);
			if(!def) {
				_textField.embedFonts = false;
				def = new TextFormat();
			} else {
				_textField.embedFonts = true;
			}
			decorateTextFormat(def);
			_textField.defaultTextFormat = def;
			_textField.multiline = _multiline;
			_textField.wordWrap = _multiline;
			if(isHTML) {
				_textField.htmlText = transformedText;
			} else {
				_textField.text = transformedText;
			}
			
			if(TextFormatManager.hasEmbeddedFont(def.font)) {
				if(TextFormatManager.canRenderText(def, transformedText)) {
					_textField.embedFonts = true;
				} else {
					def.font = "Arial";
					_textField.setTextFormat(def);
				}
			} else {
				_textField.embedFonts = false;
			}
		}
		
		/** @private */
		protected function decorateTextFormat(textFormat:TextFormat):void {
			if(_size) {
				textFormat.size = _size;
			}
			if(hasColor) {
				textFormat.color = _color;
			}
			if(_align) {
				textFormat.align = _align;
			}
		}
		
		/** @private */
		private function get transformedText():String {
			if(_textTransform == "uppercase") {
				return (_ellipsis && ellipsisText && !isHTML) ? ellipsisText.toUpperCase() : _text.toUpperCase();
				//return _text.toUpperCase();
			} else if(_textTransform == "lowercase") {
				return (_ellipsis && ellipsisText && !isHTML) ? ellipsisText.toLowerCase() : _text.toLowerCase();
				//return _text.toLowerCase();
			}
			return (_ellipsis && ellipsisText && !isHTML) ? ellipsisText : _text;
			//return _text;
		}
		
		/** @private */
		override protected function measureWithPadding(horizontal:Number, vertical:Number):void {
			if(isHTML) {
				_textField.htmlText = transformedText;
			} else {
				_textField.text = transformedText;
			}
			if(hasExplicitWidth) {
				_textField.width = _w.value - horizontal;
			} else if(multiline) {
				var parentW:Number = firstExplicitWidth;
				if(parentW != -1) {
					_textField.width = parentW;
				} else {
					_textField.width = 1000;
				}
			}
			measuredWidth = Math.ceil(_textField.textWidth + horizontal + 4 + (_icon ? _icon.width + _iconPadding : 0));
			measuredHeight = Math.ceil(Math.max(_icon ? _icon.height : 0, _textField.textHeight + vertical + 4));
		}
		
		/** @private */
		override protected function drawWithPadding(offsetX:Number, offsetY:Number, width:Number, height:Number):void {
			super.drawWithPadding(offsetX, offsetY, width, height);
			var iconW:Number = _icon ? _icon.width + _iconPadding : 0;
			_textField.x = offsetX + (_iconPlacement == "left" ? iconW : 0);
			_textField.autoSize = "none";
			_textField.width = width+1 - iconW;
			if(align == "center") {
				_textField.width = Math.floor(_textField.width/2)*2;
			}
			_textField.height = height;
			
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
				if(orgi != _text) {
					ellipsisText = _textField.text;
				} else {
					ellipsisText = _text;
				}
			}
			if(_icon) {
				if(_iconPlacement == "left") {
					_icon.x = offsetX;
				} else {
					_icon.x = offsetX + width - icon.width;
				}
				var metrics:TextLineMetrics = _textField.getLineMetrics(0);
				_icon.y = Math.round((height - _icon.height) / 2);
				_icon.visible = true;
			}
		}
	}
}