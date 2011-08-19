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
	
	import com.flow.containers.layout.LayoutBase;
	import com.flow.containers.layout.VBoxLayout;
	import com.flow.motion.Tween;
	import com.flow.motion.easing.Quadratic;
	import com.flow.utils.MultiChangeWatcher;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.binding.utils.ChangeWatcher;
	
	[DefaultProperty("view")]
	public class ViewSwapper extends Container {
				
		private var _view:DisplayObject;
		
		public function ViewSwapper() {
			super();
		}
	
		override public function validateProperties():void {
			super.validateProperties();
		}
		
		public function set view(value:DisplayObject):void {
			trace("SET VIEW");
			if(_view) {
				removeChild(_view);
			}
			_view = value;
			addChild(value);
		}
		
		public function get view():DisplayObject {
			return _view;
		}
	}
}