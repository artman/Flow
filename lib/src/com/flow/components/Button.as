
package com.flow.components {
	
	import com.flow.components.supportClasses.SkinnableComponent;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.states.State;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	
	public class Button extends SkinnableComponent {
		
		private var _label:String = "";
		private var _color:int;
		private var _labelDisplay:Label;
		
		public function Button() {
			super();
			states = [
				new State("up"),
				new State("over"),
				new State("down"),
				new State("disabled")
			];
			interactive = true;
			mouseChildren = false;
			buttonMode = useHandCursor = true;
		}
		
		[SkinPart(required="false")]
		public function set labelDisplay(value:Label):void {
			_labelDisplay = value;
			_labelDisplay.text = _label;
			BindingUtils.bindProperty(_labelDisplay, "text", this, "label", false, true);
		}
		public function get labelDisplay():Label {
			return _labelDisplay;
		}

		[Bindable]		
		public function get label():String {
			return _label;
		} 
		public function set label(value:String):void {
			_label = value;
			invalidateProperties(true);
		}
		
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