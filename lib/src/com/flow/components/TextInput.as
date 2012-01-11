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
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import mx.binding.utils.BindingUtils;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("focus")]
	[SkinState("disabled")]
	
	/**
	 * Dispatched, when the user presses enter while the TextInput has focus. 
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched, when the value of the input changes. 
	 */	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * A text input component that lets the user input one line of text. 
	 */	
	public class TextInput extends SkinnableComponent {
		/** @private */
		protected var _labelDisplay:Label;
		/** @private */
		protected var _hintDisplay:Label;
		/** @private */
		protected var _value:String = "";
		/** @private */
		protected var _restrict:String;
		/** @private */
		protected var _maxChars:int;
		/** @private */
		protected var _password:Boolean;
		/** @private */
		protected var _hint:String;

		
		/**
		 * Constructor 
		 */		
		public function TextInput() {
			super();
			interactive = true;
			focusable = true;
			addEventListener(MouseEvent.CLICK, click);
		}
		
		/**
		 * A required skin part that is used for user input. 
		 */		
		[SkinPart(required="true")]
		public function set labelDisplay(val:Label):void {
			_labelDisplay = val;
			_labelDisplay.text = _value;
			_labelDisplay.editable = true;
			_labelDisplay.textField.addEventListener(Event.CHANGE, textChanged);
			_labelDisplay.textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_labelDisplay.textField.displayAsPassword = _password;
			_labelDisplay.textField.restrict = _restrict;
			_labelDisplay.textField.maxChars = _maxChars;
			focusElement = _labelDisplay.textField;
			BindingUtils.bindProperty(_labelDisplay, "text", this, "value", false, true);
		}
		public function get labelDisplay():Label {
			return _labelDisplay;
		}
		
		/**
		 * A optional skin part that is used for displaying the TextInput hint.
		 */		
		[SkinPart(required="false")]
		public function set hintDisplay(val:Label):void {
			_hintDisplay = val;
			if(_hintDisplay) {
				_hintDisplay.mouseEnabled = _hintDisplay.mouseChildren = false
				checkHint();
			}
		}
		public function get hintDisplay():Label {
			return _hintDisplay;
		}
		
		/**
		 * Defines the text formatting to use in for the label 
		 */		
		public function get textFormat():String {
			return _labelDisplay.textFormat;
		}
		public function set textFormat(value:String):void {
			_labelDisplay.textFormat = value;
		}
		
		/**
		 * The color of the input text 
		 */		
		public function get color():int {
			return _labelDisplay.color;
		}
		public function set color(value:int):void {
			_labelDisplay.color = value;
		}
		
		/**
		 * The value of the input component. 
		 */		
		[Bindable]		
		public function get value():String {
			return _value;
		} 
		public function set value(val:String):void {
			_value = val;
			if(_labelDisplay) {
				_labelDisplay.text = val;
			}
			checkHint();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Defines which characters are allowed for input. Use the same format as you would for a Flash TextField.
		 */		
		public function get restrict():String {
			return _restrict
		}
		public function set restrict(value:String):void {
			if(value != _restrict) {
				_restrict = value;
				if(_labelDisplay) {
					_labelDisplay.textField.restrict = value;
				}
			}
		}
		
		/**
		 * The maximum characters allowed for input. 
		 */		
		public function get maxChars():int {
			return _maxChars;
		}
		public function set maxChars(value:int):void {
			if(value != _maxChars) {
				_maxChars = value;
				this.value = this.value.substr(0, value);
				if(_labelDisplay) {
					_labelDisplay.textField.maxChars = value;
				}
			}
		}
		
		/**
		 * The hint to be shown when the TextInput does not have any text. 
		 */		
		public function get hint():String {
			return _hint;
		}
		public function set hint(value:String):void {
			if(value != _hint) {
				_hint = value;
				checkHint();
			}
		}
		
		/**
		 * Defines whether the input should be obfuscated.
		 */		
		public function set password(value:Boolean):void {
			if(value != _password) {
				_password = value
				if(_labelDisplay) {
					_labelDisplay.textField.displayAsPassword = value;
				}
			}
		}
		public function get password():Boolean {
			return _password;
		}
		
		private function click(e:MouseEvent):void {
			stage.focus = _labelDisplay.textField;
			_labelDisplay.mouseEnabled = _labelDisplay.mouseChildren = true;
		}
		
		private function textChanged(e:Event):void {
			value = _labelDisplay.textField.text;
		}
		
		private function keyDown(e:KeyboardEvent):void {
			if(e.charCode == Keyboard.ENTER) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * Selects text in the text input 
		 * @param The character num to start selection from
		 * @param The character num to end the selection
		 * 
		 */		
		public function setSelection(beginIndex:int, endIndex:int):void {
			_labelDisplay.textField.setSelection(beginIndex, endIndex);
		}
		
		override public function set currentState(value:String):void {
			super.currentState = value;
			checkHint();
		}
		
		private function checkHint():void {
			if(_hintDisplay) {
				if(currentState != "focus" && value == "" && hint != "") {
					hintDisplay.text = hint;
					hintDisplay.active = true;
				} else {
					hintDisplay.active = false;
				}
			}
		}
	}
}