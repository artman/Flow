package com.flow.components.supportClasses {
	
	import com.flow.containers.Container;
	import com.flow.containers.layout.LayoutBase;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class Skin extends Container {
		
		private var _hostComponent:Container;
		
		public function Skin() {
			super();
		}
		
		public function get hostComponent():Container {
			return _hostComponent;
		}

		public function set hostComponent(value:Container):void {
			if(value != _hostComponent) {
				_hostComponent = value;
				if(_hostComponent && layout) {
					_hostComponent.layout = _layout;
				} 
			}
		}
		
		override public function set layout(value:LayoutBase):void {
			super.layout = value;
			if(_hostComponent) {
				_hostComponent.layout = layout
			}
		}
		
		override protected function checkState():void {
			// Don't do anything
		}

	}
}