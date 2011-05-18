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

package com.flow.containers.layout {
	
	import com.flow.components.Component;
	import com.flow.containers.Container;
	import com.flow.effects.Effect;
	import com.flow.motion.Tween;
	
	public class ViewStack extends Container {
		
		private var _selectedIndex:int = 0;
		private var _changeEffect:Effect;
		public var fadeSpeed:Number = 0;
		private var firstProps:Boolean = true;
		private var lastIndex:int = 0;
		
		public function ViewStack() {
			super();
			changeEffect = new Effect();
		}
		
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			if(value != _selectedIndex) {
				_selectedIndex = value;
				invalidateProperties();
			}
		}
		
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
		
		override public function validateProperties():void {
			if(children) {
				if(fadeSpeed == 0 || firstProps) {
					changeView();
				} else {
					for(var i:int = 0; i<children.length; i++) {
						if(i == lastIndex) {
							changeEffect.target = children[i];
							changeEffect.fadeTargetOut(fadeSpeed).completeHandler = changeView;
						}
					}	
				}
			}
		}
		
		private function changeView(tween:Tween = null):void {
			for(var i:int = 0; i<children.length; i++) {
				if(children[i] is Component) {
					(children[i] as Component).active = (i == selectedIndex);
				} else {
					children[i].visible = (i == selectedIndex);
				}
			}
			if(!firstProps) {
				if(fadeSpeed != 0) {
					changeEffect.target = children[selectedIndex];
					changeEffect.targetAlpha = 0;
					changeEffect.fadeTargetIn(fadeSpeed);
				}
			} else {
				firstProps = false;
			}
			lastIndex = selectedIndex;
		}
	}
}