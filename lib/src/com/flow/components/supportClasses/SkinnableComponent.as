package com.flow.components.supportClasses {
	import com.flow.containers.Container;
	import com.flow.events.InvalidationEvent;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import mx.binding.utils.BindingUtils;
	import mx.core.IFactory;

	[DefaultProperty("skinClass")]
	public class SkinnableComponent extends Container {
		
		private var _skinClass:IFactory;
		private var skinChanged:Boolean = false;
		protected var skin:Skin;
		
		public function SkinnableComponent() {
			super();
			skinChanged = true;
		}
		
		public function get skinClass():IFactory {
			return _skinClass;
		}
	
		public function set skinClass(value:IFactory):void {
			if(value != _skinClass) {
				var parts:Object = skinParts;
				if(_skinClass) {
					for (var partName:String in skinParts) {
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
					skin = _skinClass.newInstance();
					BindingUtils.bindProperty(skin, "currentState", this, "currentState", false, true);
					skin.hostComponent = this;
					children = skin.children;
					
					for (partName in parts) {
						skinPart = skin[partName];
						if (skinPart && partName in this) {
							this[partName] = skinPart;
							partAdded(partName,  skinPart);
						}
					}
					
					if(!hasExplicitWidth && skin.hasExplicitWidth) {
						width = skin.width;
					}
					if(!hasExplicitHeight && skin.hasExplicitHeight) {
						height = skin.height;
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
		
		/** @private  */		
		protected function get skinParts():Object { 
			return null;
		}
	}
}