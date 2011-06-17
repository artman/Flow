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
	
	public class PaddableComponent extends Component {
		
		private var _paddingTop:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingLeft:Number = 0;
		private var _paddingBottom:Number = 0;
		
		public function PaddableComponent() {
			super();
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
				return _paddingTop;
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
				invalidateLayout();
			}
		}
		public function get paddingRight():Number {
			return _paddingRight;
		}
		public function set paddingRight(value:Number):void {
			if(value != _paddingRight) {
				_paddingRight = value;
				invalidateLayout();
			}
		}
		public function get paddingBottom():Number {
			return _paddingBottom;
		}
		public function set paddingBottom(value:Number):void {
			if(value != _paddingBottom) {
				_paddingBottom = value;
				invalidateLayout();
			}
		}
		public function get paddingLeft():Number {
			return _paddingLeft;
		}
		public function set paddingLeft(value:Number):void {
			if(value != _paddingLeft) {
				_paddingLeft = value;
				invalidateLayout();
			}
		}
		
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
			width -= (_paddingLeft + _paddingRight);
			if(width < 0) {
				width = 0;
			}
			height -= (_paddingTop + _paddingBottom);
			if(height < 0) {
				height = 0;
			}
			drawWithPadding(_paddingLeft, _paddingTop, width, height);
		}
		
		protected function drawWithPadding(offsetX:Number, offsetY:Number, width:Number, height:Number):void {
			// Override
		}
		
		override final public function measure():void {
			measureWithPadding(_paddingLeft + _paddingRight, _paddingTop + _paddingBottom);
		}
		
		protected function measureWithPadding(horizontal:Number, vertical:Number):void {
			
		}
	}
}