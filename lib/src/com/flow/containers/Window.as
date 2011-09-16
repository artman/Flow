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
	
	import com.flow.components.Button;
	import com.flow.components.supportClasses.SkinnableComponent;
	
	import flash.events.MouseEvent;
	
	public class Window extends SkinnableComponent {
		
		
		private var _titleBar:Container;
		private var _closeButton:Button;
		private var _content:Container;
		
		/** @private */
		public function Window() {
			super();
		}
		
		[SkinPart(required="true")]
		public function get titleBar():Container {
			return _titleBar;
		}
		public function set titleBar(value:Container):void {
			if(value != _titleBar) {
				if(_titleBar) {
					_titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, titleBarDown);
				}
				_titleBar = value;
				_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, titleBarDown);
			}
		}
		
		[SkinPart(required="false")]
		public function get closeButton():Button {
			return _closeButton;
		}
		public function set closeButton(value:Button):void {
			if(value != _closeButton) {
				if(_closeButton) {
					_closeButton.removeEventListener(MouseEvent.CLICK, closeClicked);
				}
				_closeButton = value;
				_closeButton.addEventListener(MouseEvent.CLICK, closeClicked);
			}
		}
		
		[SkinPart(required="true")]
		/**
		 * A optional skin part representing the right arrow of the scrollbar. 
		 */		
		public function get content():Container {
			return _content;
		}
		public function set content(value:Container):void {
			if(value != _content) {
				_content = value;
			}
		}
		
		private function titleBarDown(e:MouseEvent):void {
		}
		
		private function closeClicked(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
	}
}