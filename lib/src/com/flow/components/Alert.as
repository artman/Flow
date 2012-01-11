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
	import com.flow.containers.Container;
	import com.flow.events.AlertEvent;
	import com.flow.managers.PopupManager;
	
	import flash.events.MouseEvent;
	
	
	/**
	 * Dispatched when the alert has been dismissed. The buttonIndex of the dispatched event will hold the index of the button that was used to dismiss the dialog.
	 */	
	[Event(name="alertDismissed", type="com.flow.events.AlertEvent")]
	
	/**
	 * Create a simple Alert dialog. 
	 */	
	public class Alert extends SkinnableComponent {
		
		private var _title:String;
		private var _text:String;
		private var _buttons:Array;
		
		private var _titleLabel:Label;
		private var _contentLabel:Label;
		private var _buttonContainer:Container;
		
		private var defaultButton:Button;
		
		/**
		 * Creates a simple Alert dialog. 
		 * @param The title for the dialog.
		 * @param The text to display for the dialog.
		 * @param An array of Button instances to attach to the dialog.
		 * @return An instance of an Alert dialog.
		 */		
		public static function show(title:String, text:String, buttonsToShow:Array):Alert {
			var alert:Alert = new Alert();
			alert.title = title;
			alert.text = text;
			alert.buttons = buttonsToShow;
			PopupManager.addPopup(alert);
			return alert;
		}
		
		/**
		 * Consturctor. Don't create an instance directly. Intead, use the show-method
		 * @see #show  
		 */		
		public function Alert() {
			_buttons = [];
			super();
		}
		
		/**
		 * A required skin-part that is used to display the title text. 
		 */		  
		[SkinPart(required="true")]
		public function get titleLabel():Label {
			return _titleLabel;
		}
		public function set titleLabel(value:Label):void {
			if(value != _titleLabel) {
				_titleLabel = value;
				if(_titleLabel) {
					_titleLabel.text = title;
				}
			}
		}
		
		/**
		 * A required skin-part that is used to display the contet text. 
		 */		
		[SkinPart(required="true")]		
		public function get contentLabel():Label {
			return _contentLabel;
		}
		public function set contentLabel(value:Label):void {
			if(value != _contentLabel) {
				_contentLabel = value;
				_contentLabel.text = _text;
			}
		}
		
		/**
		 * A required skin-part to hold all buttons that are attached to the Alert dialog. 
		 */		
		[SkinPart(required="true")]		
		public function get buttonContainer():Container {
			return _buttonContainer;
		}
		public function set buttonContainer(value:Container):void {
			if(value != _buttonContainer) {
				_buttonContainer = value;
				if(_buttonContainer) {
					defaultButton = _buttonContainer.getChildAt(0) as Button;
					while(_buttonContainer.numChildren) {
						_buttonContainer.removeChildAt(0);
					}
					setButtons();
				}
			}
		}	

		/**
		 * The title for the Alert dialog. 
		 */		
		[Bindable]
		public function get title():String {
			return _title;
		}
		public function set title(value:String):void {
			_title = value;
			if(_titleLabel) {
				_titleLabel.text = _title;
			}
		}

		/**
		 * The content text of the dialog. 
		 */		
		[Bindable]
		public function get text():String {
			return _text;
		}
		public function set text(value:String):void {
			_text = value;
			if(_contentLabel) {
				_contentLabel.text = _text;
			}
		}

		/**
		 * An array of buttons to be attached to the Alert dialog. 
		 */		
		[Bindable]
		public function get buttons():Array {
			return _buttons;
		}
		public function set buttons(value:Array):void {
			_buttons = value;
			setButtons();
		}
		
		private function setButtons():void {
			if(_buttonContainer && _buttons && defaultButton) {
				for(var i:int = 0; i<_buttons.length; i++) {
					var btn:Button = defaultButton.copyInstance();
					btn.label = _buttons[i];
					btn.addEventListener(MouseEvent.CLICK, btnClicked);
					_buttonContainer.addChild(btn);
				}
			}
		}
		
		/** @private */
		protected function btnClicked(event:MouseEvent):void {
			for(var i:int = 0; i<_buttonContainer.numChildren; i++) {
				if(_buttonContainer.getChildAt(i) == event.currentTarget) {
					var evt:AlertEvent = new AlertEvent(AlertEvent.ALERT_DISMISSED);
					evt.buttonIndex = i;
					dispatchEvent(evt);
					PopupManager.removePopup(this);
				}
			}
		}
	}
}