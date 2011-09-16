package com.flow.components {
	import com.flow.containers.Container;
	import com.flow.events.InvalidationEvent;
	
	import flash.events.Event;

	[DefaultProperty("skinClass")]
	public class SkinnableComponent extends Component {
		
		private var _skinClass:Class;
		private var skinChanged:Boolean = false;
		protected var skin:Skin;
		
		public function SkinnableComponent() {
			super();
			skinChanged = true;
		}
		
		public function get skinClass():Class {
			return _skinClass;
		}
		public function set skinClass(value:Class):void {
			if(value != _skinClass) {
				_skinClass = value;
				skinChanged = true;
				if(_skinClass) {
					skin = new _skinClass();
					skin.hostComponent = this;
					skin.left = left;
					skin.top = top;
					skinApplied();
				}
				invalidateLayout();
			}
		}
		
		protected function skinApplied():void {
		}
		
		override public function get visualRepresentation():Component {
			return skin;
		}
		
		override public function validateProperties():void {
			if(skinChanged) {
				if(skin) {
					//removeChild(skin);
					//skin.removeEventListener(InvalidationEvent.INVALIDATE_LAYOUT, skinLayoutInvalidated);
				}
				skinChanged = false;
				if(_skinClass){
					skin = new _skinClass();
					//skin.addEventListener(InvalidationEvent.INVALIDATE_LAYOUT, skinLayoutInvalidated);
				}
			}
			super.validateProperties();
		}
		
		protected function skinLayoutInvalidated(event:InvalidationEvent):void {
			invalidate();
		}
		
		override public function invalidate(e:Event=null):void {
			if(skin) {
				skin.invalidate();
			}
		}
		
		override public function invalidateLayout(fromChild:Boolean=false):void {
			if(skin) {
				skin.invalidateLayout(fromChild);
			}
		}
		
		
		override public function set left(value:*):void {
			if(skin) skin.left = value; else super.left = value;
		}
		
		override public function set top(value:*):void {
			if(skin) skin.top = value; else super.top = value;
		}
		
		
		
		
		/*
		override public function validate():void {
			super.validate();
			if(skin) {
				skin.validate();
			}
		}
		*/
		
	}
}