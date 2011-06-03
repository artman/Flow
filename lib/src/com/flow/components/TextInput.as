
package com.flow.components {
	
	import com.flow.components.supportClasses.SkinnableComponent;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	
	import mx.binding.utils.BindingUtils;
	import mx.states.State;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	
	public class TextInput extends SkinnableComponent {
		
		private var _labelDisplay:Label;
		private var _value:String = "";
		private var _restrict:String;
		private var _maxChars:int;
		private var _password:Boolean;
		
		public function TextInput() {
			super();
			states = [
				new State("up"),
				new State("over"),
				new State("down"),
				new State("focus"),
				new State("disabled")
			];
			interactive = true;
			focusable = true;
			addEventListener(MouseEvent.CLICK, click);
		}
		
		[SkinPart(required="true")]
		public function set labelDisplay(val:Label):void {
			_labelDisplay = val;
			_labelDisplay.text = _value;
			_labelDisplay.editable = true;
			_labelDisplay.textField.addEventListener(Event.CHANGE, textChanged);
			_labelDisplay.textField.displayAsPassword = _password;
			_labelDisplay.textField.restrict = _restrict;
			_labelDisplay.textField.maxChars = _maxChars;
			BindingUtils.bindProperty(_labelDisplay, "text", this, "value", false, true);
		}
		public function get labelDisplay():Label {
			return _labelDisplay;
		}
		
		public function get textFormat():String {
			return _labelDisplay.textFormat;
		}
		public function set textFormat(value:String):void {
			_labelDisplay.textFormat = value;
		}
		
		public function get color():int {
			return _labelDisplay.color;
		}
		public function set color(value:int):void {
			_labelDisplay.color = value;
		}
		
		[Bindable]		
		public function get value():String {
			return _value;
		} 
		public function set value(val:String):void {
			_value = val;
			if(_labelDisplay) {
				_labelDisplay.text = val;
			}
		}
		
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
	}
}