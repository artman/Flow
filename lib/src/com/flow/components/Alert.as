package com.flow.components
{
	import com.flow.components.supportClasses.SkinnableComponent;
	import com.flow.containers.Container;
	import com.flow.containers.Window;
	import com.flow.events.AlertEvent;
	import com.flow.managers.PopupManager;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Alert extends SkinnableComponent {
		
		private var _title:String;
		private var _text:String;
		private var _buttons:Array;
		
		private var _titleLabel:Label;
		private var _contentLabel:Label;
		private var _buttonContainer:Container;
		
		private var defaultButton:Button;
		
		
		public static function show(title:String, text:String, buttonsToShow:Array):void {
			var alert:Alert = new Alert();
			alert.title = title;
			alert.text = text;
			alert.buttons = buttonsToShow;
			PopupManager.addPopup(alert);
		}
		
		public function Alert() {
			_buttons = [];
			super();
		}
		
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