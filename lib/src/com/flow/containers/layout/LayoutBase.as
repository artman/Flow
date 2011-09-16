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
	
	import flash.display.DisplayObject;
	
	public class LayoutBase {
		
		public function LayoutBase() {}
		protected var _target:Container;
	
		protected var _paddingLeft:Number = 0;
		protected var _paddingRight:Number = 0;
		protected var _paddingBottom:Number = 0;
		protected var _paddingTop:Number = 0;
		
		public function invalidate():void {
			if(_target) {
				_target.invalidateLayout();
			}
		}
		
		public function assignToComponent(target:Container):void {
			this._target = target;
			invalidate();
		}
		
		public function resignFromComponent(target:Container):void {
			this._target = null;
		}
		
		public function childrenChanged():void {
			// Override
		}
		
		final public function layout(w:Number, h:Number):void {
			if(_target) {
				layoutChildren(_paddingLeft, _paddingTop, w-_paddingLeft - _paddingRight, h-_paddingTop-_paddingBottom);
			}
		}
		
		public function layoutChildren(offsetX:Number, offsetY:Number, w:Number, h:Number):void {
			// Override
		}
		
		
		public function get padding():Number {
			if(_paddingTop == _paddingBottom && _paddingBottom == _paddingLeft && _paddingLeft == _paddingRight) {
				return _paddingTop
			}
			return 0;
		}
		public function set padding(value:Number):void {
			paddingTop = paddingBottom = paddingLeft = paddingRight = value;
		}
		
		public function get verticalPadding():Number {
			if(_paddingTop == _paddingBottom) {
				return _paddingTop
			}
			return 0;
		}
		public function set verticalPadding(value:Number):void {
			paddingTop = paddingBottom = value;
		}
		
		public function get horizontalPadding():Number {
			if(_paddingLeft == _paddingRight) {
				return _paddingLeft;
			}
			return 0;
		}
		public function set horizontalPadding(value:Number):void {
			paddingLeft = paddingRight = value;
		}
		
		public function get paddingTop():Number {
			return _paddingTop;
		}
		public function set paddingTop(value:Number):void {
			if(value != _paddingTop) {
				_paddingTop = value;
				invalidate();
			}
		}
		public function get paddingRight():Number {
			return _paddingRight;
		}
		public function set paddingRight(value:Number):void {
			if(value != _paddingRight) {
				_paddingRight = value;
				invalidate();
			}
		}
		public function get paddingBottom():Number {
			return _paddingBottom;
		}
		public function set paddingBottom(value:Number):void {
			if(value != _paddingBottom) {
				_paddingBottom = value;
				invalidate();
			}
		}
		public function get paddingLeft():Number {
			return _paddingLeft;
		}
		public function set paddingLeft(value:Number):void {
			if(value != _paddingLeft) {
				_paddingLeft = value;
				invalidate();
			}
		}
		
		final public function measure():void {
			if(_target) {
				measureChildren();
				_target.measuredWidth += _paddingLeft + _paddingRight;
				_target.measuredHeight += _paddingTop + _paddingBottom;
			}
		}
		
		public function measureChildren():void {
		
		}
		
		protected function getWidth(displayObject:DisplayObject):int {
			if(displayObject is Component) {
				return (displayObject as Component).absoluteWidth;
			}
			return displayObject.width;
		}
		
		protected function getHeight(displayObject:DisplayObject):int {
			if(displayObject is Component) {
				return (displayObject as Component).absoluteHeight;
			}
			return displayObject.height;
		}
	}
}