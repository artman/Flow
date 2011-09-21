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

package com.flow.containers {
	
	import com.flow.components.Component;
	import com.flow.effects.Effect;
	import com.flow.motion.Tween;
	
	import flash.display.DisplayObject;
	
	/**
	 * A container with one child visible at a time. 
	 */	
	public class ViewStack extends Container {
		private var _selectedIndex:int = 0;
		private var _changeEffect:Effect;
		private var _fadeSpeed:Number = 0;
		private var firstProps:Boolean = true;
		private var lastIndex:int = 0;
		
		/**
		 * Constructor 
		 */		
		public function ViewStack() {
			super();
			changeEffect = new Effect();
		}
		
		/**
		 * The index of the child that is visible within the view stack. Setting this property will change the visible child. 
		 */	
		[Bindable]
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			if(value != _selectedIndex) {
				_selectedIndex = value;
				invalidateProperties();
			}
		}
		
		/**
		 * The current visible view. You may also set this to a child of the ViewStack.
		 */		
		[Bindable]
		public function get selectedView():DisplayObject {
			return _children.getItemAt(_selectedIndex) as DisplayObject;
		}
		
		public function set selectedView(value:DisplayObject):void {
			var index:int = _children.getItemIndex(value);
			if(index != -1) {
				selectedIndex = index;
			}
		}
		
		/**
		 * The effect to use when swapping children. If null, children are swapped instantaneously.
		 */		
		public function get changeEffect():Effect {
			return _changeEffect;
		}
		public function set changeEffect(value:Effect):void {
			if(value != _changeEffect) {
				if(value) {
					_changeEffect = value;
				} else {
					_changeEffect = new Effect();
				}
			}
		}
		
		/** @private */		
		override public function validateProperties():void {
			super.validateProperties();
			if(children) {
				if(fadeSpeed == 0 || firstProps) {
					changeView();
				} else {
					for(var i:int = 0; i<_children.length; i++) {
						if(i == lastIndex) {
							changeEffect.target = _children.getItemAt(i) as DisplayObject;
							changeEffect.fadeTargetOut(fadeSpeed).completeHandler = changeView;
						}
					}	
				}
			}
		}
		
		private function changeView(tween:Tween = null):void {
			for(var i:int = 0; i<children.length; i++) {
				if(_children.getItemAt(i) is Component) {
					(_children.getItemAt(i) as Component).active = (i == _selectedIndex);
				} else {
					children.getItemAt(i).visible = (i == _selectedIndex);
				}
			}
			if(!firstProps) {
				if(fadeSpeed != 0) {
					changeEffect.target = _children.getItemAt(_selectedIndex) as DisplayObject;
					changeEffect.targetAlpha = 0;
					changeEffect.fadeTargetIn(fadeSpeed);
				}
			} else {
				firstProps = false;
			}
			lastIndex = selectedIndex;
		}

		/**
		 * The speed in seconds at which to transition from one view to another. If no effect has been set, new views will be faded in,
		 * otherwise the effect is beeing played with the given speed.
		 */		
		public function get fadeSpeed():Number {
			return _fadeSpeed;
		}

		public function set fadeSpeed(value:Number):void {
			_fadeSpeed = value;
		}

	}
}