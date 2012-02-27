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
	
	import com.flow.containers.Container;
	import com.flow.containers.layout.LayoutBase;
	
	/**
	 * The base class for all component skins
	 */	
	public class Skin extends Container {
		
		private var _hostComponent:Container;
		
		/**
		 * Constructor.
		 */		
		public function Skin() {
			super();
		}
		
		/**
		 * The host component of the skin. You set this via metadata, e.g.:
		 * <code>[HostComponent("com.flow.components.Button")]</code>
		 */		
		[Bindable]
		public function get hostComponent():Container {
			return _hostComponent;
		}
		public function set hostComponent(value:Container):void {
			_hostComponent = value;
			if(_hostComponent && layout) {
				_hostComponent.layout = _layout;
			} 
		}
		
		/** @inheritDoc */
		override public function set layout(value:LayoutBase):void {
			super.layout = value;
			if(_hostComponent) {
				_hostComponent.layout = layout
			}
		}
		
		/** @private */
		override protected function checkState():void {
			// Don't do anything
		}

	}
}