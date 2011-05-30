package com.flow.components {
	import com.flow.containers.Container;
	import com.flow.events.InvalidationEvent;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;

	[DefaultProperty("skinClass")]
	public class SkinnableComponent extends Container {
		
		private var _skinClass:Class;
		private var skinChanged:Boolean = false;
		protected var skin:Skin;
		private var _skinParts:Object;
		
		public function SkinnableComponent() {
			super();
			skinChanged = true;
		}
		
		public function get skinClass():Class {
			return _skinClass;
		}
		public function set skinClass(value:Class):void {
			if(value != _skinClass) {
				if(_skinClass) {
					for (var partName:String in _skinParts) {
						var skinPart:InteractiveObject = this[partName];
						if (skinPart) {
							this[partName] = null;
							partRemoved(partName, skinPart);
						}
					}
				}
				
				_skinClass = value;
				skinChanged = true;
				if(_skinClass) {
					skin = new _skinClass();
					skin.hostComponent = this;
					children = skin.children;
					
					for (partName in _skinParts) {
						skinPart = skin[partName];
						if (skinPart && partName in this) {
							this[partName] = skinPart;
							partAdded(partName,  skinPart);
						}
					}
					skinAttached();
				}
				invalidateLayout();
			}
		}
		
		override public function set children(value:*):void {
			if(skin) {
				super.children = skin.children;
			}
		}
		
		override public function validateChildren():void {
			super.validateChildren();
		}
		
		
		protected function get skinParts():Object { 
			return _skinParts; 
		}
		protected function set skinParts(value:Object):void {
			_skinParts = {};
			for (var i:String in value) {
				_skinParts[i] = value[i];
			}
		}
		
		protected function skinAttached():void {
			// Override
		}
		
		protected function skinDetached():void {
			// Override
		}
		
		protected function partAdded(partName:String, skinPart:InteractiveObject):void {
			// Override
		}
		
		protected function partRemoved(partName:String, skinPart:InteractiveObject):void {
			// Override
		}
	}
}