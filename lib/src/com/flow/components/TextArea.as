package com.flow.components {
	
	import com.flow.components.TextInput;
	
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	
	public class TextArea extends TextInput {
		
		public var allowEnter:Boolean = true;
		
		public function TextArea() {
			super();
		}
		
		/** @inheritDoc */		
		[SkinPart(required="true")]
		override public function set labelDisplay(value:Label):void {
			super.labelDisplay = value;
			if(_labelDisplay) {
				_labelDisplay.multiline = true;
				_labelDisplay.textField.addEventListener(TextEvent.TEXT_INPUT, textInput);
			}
		}
		override public function get labelDisplay():Label {
			return _labelDisplay;
		}
		
		protected function textInput(e:TextEvent):void {
			if(!allowEnter && e.text.charCodeAt() == 10) {
				e.preventDefault();
			}
		}
	}
}