
package com.flow.components {
	
	import flash.events.MouseEvent;
	
	import mx.states.State;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	
	public class Checkbox extends Button {
		
		private var _selected:Boolean;
		
		public function Checkbox() {
			super();
			states = [
				new State("up"),
				new State("over"),
				new State("down"),
				new State("disabled")
			];
			addEventListener(MouseEvent.CLICK, click);
		}
		
		private function click(e:MouseEvent):void {
			selected = !_selected;
		}
		
		
		[Bindable]
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(value:Boolean):void {
			if(value != _selected) {
				_selected = value;
			}
		}
	
	}
}