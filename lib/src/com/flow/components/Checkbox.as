
package com.flow.components {
	
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	
	public class Checkbox extends Button {
		
		private var _selected:Boolean = false;
		private var _checker:Component;
		
		public function Checkbox() {
			super();
			addEventListener(MouseEvent.CLICK, click);
		}
		
		[SkinPart(required="false")]
		override public function set labelDisplay(value:Label):void {
			super.labelDisplay = value;
		}
		
		[SkinPart(required="true")]
		public function set checker(value:Component):void {
			_checker = value;
			_checker.active = _selected;
			BindingUtils.bindProperty(_checker, "active", this, "selected", false, true);
		}
		public function get checker():Component {
			return _checker;
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