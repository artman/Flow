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

package com.flow.components.graphics {
	
	[DefaultProperty("fill")]
	public class Rect extends Geometry {
		
		private var _radius:Number = 0;
		private var _radiusX:Number = 0;
		private var _radiusY:Number = 0;
		
		private var _bottomLeftRadius:Number = 0;
		private var _bottomRightRadius:Number = 0;
		private var _topLeftRadius:Number = 0;
		private var _topRightRadius:Number = 0;

		public function Rect() {
			super();
			stroke = null;
		}
		
		public function get radius():Number {
			return _radius;
		}
		public function set radius(value:Number):void {
			if(value != _radius) {
				_radius = value;
				invalidate();
			}
		}
		
		public function get radiusX():Number {
			return _radiusX;
		}
		public function set radiusX(value:Number):void {
			if(value != _radiusX) {
				_radiusX = value;
				invalidate();
			}
		}
		
		public function get radiusY():Number {
			return _radiusY;
		}
		public function set radiusY(value:Number):void {
			if(value != _radiusY) {
				_radiusY = value;
				invalidate();
			}
		}
		
		override protected function draw(width:int, height:int):void {
			super.draw(width, height);
			
			if (_radiusX || _radiusY) {
				graphics.drawRoundRect(0, 0, width, height, _radiusX, _radiusY);
			} else if(_radius) {
				graphics.drawRoundRect(0, 0, width, height, _radius, _radius);
			} else {
				graphics.drawRect(0,0, width, height);
			}
			endDraw();
		}
	}
}