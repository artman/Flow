
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
		public function set labelDisplay(value:Label):void {
			_labelDisplay = value;
			BindingUtils.bindProperty(_labelDisplay, "text", this, "label", false, true);
		}
		public function get labelDisplay():Label {
			return _labelDisplay;
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