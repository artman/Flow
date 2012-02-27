/**
 * Copyright (c) 2011 Tuomas Artman, http://artman.fi
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.flow.components.supportClasses {
	
	import com.flow.components.Component;
	import com.flow.containers.Container;
	import com.flow.managers.IntrospectionManager;
	import com.flow.managers.SkinManager;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.core.IFactory;

	/**
	 * The base class for all skinnable components. 
	 */	
	[DefaultProperty("skinClass")]
	public class SkinnableComponent extends Container {
		
		private var _skinClass:IFactory;
		private var skinChanged:Boolean = true;
		
		/**
		 * The skin that has been assigned to the component. You can use it if you need to pass in additional values to the skin that are not
		 * directly supported by the host component. 
		 */		
		public var skin:Skin;
		
		public function SkinnableComponent() {
			super();
		}
		
		/**
		 * The skin class (a Component) to use for the component 
		 */		
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
		
		/** @private */
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
		
		/** @private */
		override protected function get stateTarget():Component {	
			return skin;
		}
		
		/** @private */
		override public function set children(value:*):void {
			if(skin) {
				super.children = skin.children;
			}
		}
		
		/**
		 * Override this method if you want to perform some actions when a skin has been attached.
		 */		
		protected function skinAttached():void {
			// Override
		}
		
		/**
		 * Override this method if you want to perform some actions when a skin has been detached. 
		 */		
		protected function skinDetached():void {
			// Override
		}
		
		/**
		 * Called whenever a skin part has been added to the component. Override this to update your components properties with
		 * the added skin part. 
		 * @param The name of the part added.
		 * @param The instance of the added part.
		 */		
		protected function partAdded(partName:String, skinPart:InteractiveObject):void {
			// Override
		}
		
		/**
		 * Called whenever a skin part has been removed from the component. Override this to update your components properties.
		 * @param The name of the part that has been removed.
		 * @param The instance of the removed part.
		 * 
		 */	
		protected function partRemoved(partName:String, skinPart:InteractiveObject):void {
			// Override
		}
		
		/** @private  */		
		protected function get skinParts():Object { 
			return null;
		}
		
		/**
		 * The default skin class to use in case the user has not assigned the skinClass property for the component.
		 */		
		protected function get defaultSkin():Skin {
			var skinClass:Class = SkinManager.getDefaultSkin(IntrospectionManager.getClassName(this));
			if(skinClass) {
				return new skinClass();
			}
			return null;
		}
	}
}