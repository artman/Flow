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
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	[DefaultProperty("view")]
	/**
	 * A simple container that will show one view at a time.
	 */	
	public class ViewSwapper extends ViewStack {
				
		private var _view:DisplayObject;
		
		/**
		 * Constructor 
		 */		
		public function ViewSwapper() {
			super();
			addChild(new Sprite());
		}
	
		/** @private */
		override public function validateProperties():void {
			super.validateProperties();
		}
		
		/**
		 * The view to show. Setting this will throw out the old view. 
		 */		
		public function set view(value:DisplayObject):void {
			if(!_view) {
				removeChild(_view);
				addChildAt(value, 0);
			} else {
				if(value is Component) {
					(value as Component).active = false;
				} else {
					value.alpha = 0;
				}
				if(selectedIndex == 1) {
					removeChildAt(0);
					addChildAt(value, 0);
					selectedIndex = 0;
				} else {
					removeChildAt(1);
					addChildAt(value, 1);
					selectedIndex = 1;
				}
			}
			_view = value;
		}
		public function get view():DisplayObject {
			return _view;
		}
	}
}