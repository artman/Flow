package com.flow.components {
	
	import com.flow.containers.Container;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class Skin extends Container {
		
		public var hostComponent:Component;
		
		public function Skin() {
			super();
		}
		
		override public function dispatchEvent(event:Event):Boolean {
			return hostComponent.dispatchEvent(event);
			super.dispatchEvent(event);
		}
	}
}