package com.flow.components {
	
	import com.flow.containers.Container;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class Skin extends Container {
		
		private var _hostComponent:Component;
		
		public function Skin() {
			super();
		}
		
		override public function dispatchEvent(event:Event):Boolean {
			return hostComponent.dispatchEvent(event);
			super.dispatchEvent(event);
		}
		
		public function get hostComponent():Component {
			return _hostComponent;
		}

		public function set hostComponent(value:Component):void {
			if(value != _hostComponent) {
				_hostComponent = value;
			}
		}
		
		override public function get height():Number
		{
			// TODO Auto Generated method stub
			return hostComponent.height;
		}
		
		override public function get horizontalCenter():*
		{
			// TODO Auto Generated method stub
			return hostComponent.horizontalCenter;
		}
		
		override public function get left():*
		{
			// TODO Auto Generated method stub
			return hostComponent.left;
		}
		
		override public function get percentHeight():Number
		{
			// TODO Auto Generated method stub
			return hostComponent.percentHeight;
		}
		
		override public function get percentWidth():Number
		{
			// TODO Auto Generated method stub
			return hostComponent.percentWidth;
		}
		
		override public function get right():*
		{
			// TODO Auto Generated method stub
			return hostComponent.right;
		}
		
		override public function get top():*
		{
			// TODO Auto Generated method stub
			return hostComponent.top;
		}
		
		override public function get verticalCenter():*
		{
			// TODO Auto Generated method stub
			return hostComponent.verticalCenter;
		}
		
		override public function get visible():Boolean
		{
			// TODO Auto Generated method stub
			return hostComponent.visible;
		}
		
		override public function get width():Number	{
			return hostComponent.width;
		}
		
		override public function get x():Number	{
			return hostComponent.x;
		}
		
		override public function get y():Number {
			return hostComponent.y;
		}
		
		
		
		
	}
}