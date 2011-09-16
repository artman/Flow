
package com.flow.components {
	
	import com.flow.components.graphics.Image;
	
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import mx.states.State;
	
	public class Button extends SkinnableComponent {
		
		private var _label:String;
		private var _color:int;
		
		
		[SkinPart(required="true")]
		public function set labelDisplay(value:Label):void {
			trace("SETTING");
		}
		public function get labelDisplay():Label {
			return null;
		}
		
		
		public function Button() {
			super();
			states = [
				new State("normal"),
				new State("hover"),
				new State("down"),
				new State("disabled")
			];
		}
		
		override protected function skinAttached():void {
			skin.buttonMode = true;
			skin.mouseChildren = false;
			skin.useHandCursor = true;
			skin.interactive = true;
		}

		private function disableClick(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		
		public function set label(value:String):void {
			_label = value;
			invalidateProperties(true);
			trace(labelDisplay);
		}
		public function get label():String {
			return _label;
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
		
		
		override protected function partAdded(partName:String, skinPart:InteractiveObject):void {
			trace(partName + "xxxx");
		}
	}
}