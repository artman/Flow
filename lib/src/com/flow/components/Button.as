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
	
	import com.flow.components.supportClasses.SkinnableComponent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import mx.binding.utils.BindingUtils;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	
	/**
	 * A generic, skinnable Button component. A button displays a label and can be clicked. 
	 */	
	public class Button extends SkinnableComponent {
		
		private var _label:String = "";
		private var _color:int;
		private var _labelDisplay:Label;
		private var _icon:DisplayObject;
		private var _textFormat:String;
		
		/** Constructor */
		public function Button() {
			super();
			interactive = true;
			mouseChildren = false;
			buttonMode = useHandCursor = true;
			
		}
		
		/**
		 * A label skin part to display the label-property of the Button.
		 */		
		[SkinPart(required="false")]
		public function get labelDisplay():Label {
			return _labelDisplay;
		}
		public function set labelDisplay(value:Label):void {
			_labelDisplay = value;
			if(_textFormat) {
				_labelDisplay.textFormat = _textFormat;
			}
			BindingUtils.bindProperty(_labelDisplay, "text", this, "label", false, true);
		}
		
		/**  The label of the button  */		
		[Bindable]		
		public function get label():String {
			return _label;
		} 
		public function set label(value:String):void {
			_label = value;
			invalidateProperties(true);
		}
		
		/**
		 * Defines the text formatting to use in for the label 
		 */		
		public function get textFormat():String {
			return _textFormat;
		}
		public function set textFormat(value:String):void {
			if(_textFormat != value) {
				_textFormat = value;
				if(_labelDisplay) {
					_labelDisplay.textFormat = _textFormat;
				}
			}
		}
		
		/**
		 * The icon for the button. To use this property, the button skin must implement the labelDisplay-element. The icon is assigned
		 * to the labelDisplay-element. 
		 */		
		public function get icon():DisplayObject {
			return _icon;
		}
		public function set icon(value:DisplayObject):void {
			if(value != _icon) {
				_icon = value;
				invalidateProperties();
			}
		}
		
		/** @private */  
		override public function validateProperties():void {
			super.validateProperties();
			if(_labelDisplay) {
				_labelDisplay.text = _label;
				_labelDisplay.icon = _icon
			}
		}
		
		/** @inheritDoc */
		override public function set disabled(value:Boolean):void {
			super.disabled = value;
			if(value) {
				addEventListener(MouseEvent.CLICK, disableClick, false, 1000);
				useHandCursor = false;
			} else {
				removeEventListener(MouseEvent.CLICK, disableClick);
				useHandCursor = true;
			}
		}
	
		private function disableClick(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
	}
}