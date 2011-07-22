package com.flow.components {
	
	import com.flow.components.TextInput;
	
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	
	/**
	 * A text area component that displays multiple lines of text and can be used by the user to input text. 
	 */	
	public class TextArea extends TextInput {
		
		/** Whether to allow the entry of a carriage return  */		
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
		
		/** @private */
		protected function textInput(e:TextEvent):void {
			if(!allowEnter && e.text.charCodeAt() == 10) {
				e.preventDefault();
			}
		}
	}
}