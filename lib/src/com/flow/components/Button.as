
package com.flow.components {
	
	import com.flow.components.graphics.Image;
	
	import flash.events.MouseEvent;
	
	import mx.states.State;
	
	public class Button extends SkinnableComponent {
		
		private var _label:String;
		private var _color:int;
		
		public function Button() {
			super();
			states = [
				new State("normal"),
				new State("hover"),
				new State("down"),
				new State("disabled")
			]
		}
		
		override protected function skinApplied():void {
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
		
		override public function validateProperties():void {
		
		}
		
		override public function measure():void {
			
		}
		
		override public function draw(width:int, height:int):void {
			super.draw(width, height);
		}
	}
}