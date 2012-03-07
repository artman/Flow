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

package com.flow.components {
	import flash.events.MouseEvent;

	/**
	 * A button that can be pushed down and stays down
	 */	
	[SkinState("selected")]
	
	public class PushButton extends Button {
	
		private var _selected:Boolean = false;
		private var _pushOnly:Boolean = false;
		
		public function PushButton() {
			super();
			addEventListener(MouseEvent.CLICK, toggle);
		}
		
		private function toggle(e:MouseEvent):void {
			if(!pushOnly || !selected) {
				selected = !selected;
			}
		}
		
		/**
		 * The selected state of the button. 
		 */		
		[Bindable]
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(value:Boolean):void {
			_selected = value;
			if(_selected) {
				addState("selected");
			} else {
				removeState("selected");
			}
		}
		
		[Bindable]
		public function get pushOnly():Boolean {
			return _pushOnly;
		}
		public function set pushOnly(value:Boolean):void {
			_pushOnly = value;
		}
	}
}