package com.flow.components.supportClasses {
	import com.flow.components.Checkbox;
	import com.flow.components.Component;
	import com.flow.containers.Container;
	import com.flow.events.InvalidationEvent;
	import com.flow.managers.IntrospectionManager;
	import com.flow.managers.SkinManager;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.core.IFactory;

	[DefaultProperty("skinClass")]
	public class SkinnableComponent extends Container {
		
		private var _skinClass:IFactory;
		private var skinChanged:Boolean = true;
		protected var skin:Skin;
		
		public function SkinnableComponent() {
			super();
		}
		
		public function get skinClass():IFactory {
			return _skinClass;
		}
	
		public function set skinClass(value:IFactory):void {
			if(value != _skinClass) {
				_skinClass = value;
				skinChanged = true;
				invalidateProperties();
			}
		}
		
		override public function validateProperties():void {
			if(skinChanged) {
				skinChanged = false;
				var parts:Object = skinParts;
				if(skin) {
					for (var partName:String in skinParts) {
						var skinPart:InteractiveObject = this[partName];
						if (skinPart) {
							this[partName] = null;
							partRemoved(partName, skinPart);
						}
					}
				}
				
				if(!_skinClass) {
					_skinClass = defaultSkin;
				}
				if(_skinClass) {
					skin = _skinClass.newInstance();
					skin.hostComponent = this;

					states = skin.states;
					children = skin.children;
					
					for (partName in parts) {
						if (partName in skin) {
							skinPart = skin[partName];
							this[partName] = skinPart;
							partAdded(partName,  skinPart);
						}
					}
					
					if(!hasExplicitWidth) {
						ChangeWatcher.watch(skin, "width", skinWidthChange);
						if(skin.hasExplicitWidth) {
							skinWidthChange();
						}
					}
					if(!hasExplicitHeight) {
						ChangeWatcher.watch(skin, "height", skinHeightChange);
						if(skin.hasExplicitHeight) {
							skinHeightChange();
						}
					}
					skin.currentState = currentState;
					skinAttached();
				} else {
					throw new Error("No skinClass defined and could not retreive default skin")
				}
			}
			super.validateProperties();
		}
		
		private function skinWidthChange(e:Event = null):void {
			width = skin.width;
		}
		
		private function skinHeightChange(e:Event = null):void {
			height = skin.height;
		}
		
		override protected function get stateTarget():Component {	
			return skin;
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
		
		protected function get defaultSkin():Skin {
			var skinClass:Class = SkinManager.getDefaultSkin(IntrospectionManager.getClassName(this));
			if(skinClass) {
				return new skinClass();
			}
			return null;
		}
	}
}