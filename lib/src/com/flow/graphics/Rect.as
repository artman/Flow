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

package com.flow.graphics {
	
	[DefaultProperty("fill")]
	public class Rect extends Geometry {
		
		private var _radius:Number = 0;
		
		private var _topLeftRadius:Number = 0;
		private var _topRightRadius:Number = 0;
		private var _bottomLeftRadius:Number = 0;
		private var _bottomRightRadius:Number = 0;

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
		
		public function get topLeftRadius():Number {
			return _topLeftRadius;
		}
		public function set topLeftRadius(value:Number):void {
			if(value != _topLeftRadius) {
				_topLeftRadius = value;
				invalidate();
			}
		}
		
		public function get topRightRadius():Number {
			return _topRightRadius;
		}
		public function set topRightRadius(value:Number):void {
			if(value != _topRightRadius) {
				_topRightRadius = value;
				invalidate();
			}
		}
		
		public function get bottomLeftRadius():Number {
			return _bottomLeftRadius;
		}
		public function set bottomLeftRadius(value:Number):void {
			if(value != _bottomLeftRadius) {
				_bottomLeftRadius = value;
				invalidate();
			}
		}
		
		public function get bottomRightRadius():Number {
			return _bottomRightRadius;
		}
		public function set bottomRightRadius(value:Number):void {
			if(value != _bottomRightRadius) {
				_bottomRightRadius = value;
				invalidate();
			}
		}
		
		
		
		override public function draw(width:int, height:int):void {
			super.draw(width, height);
			
			if (_topLeftRadius || _topRightRadius || _bottomRightRadius, _bottomLeftRadius) {
				graphics.drawRoundRectComplex(0, 0, width, height, _topLeftRadius, _topRightRadius, _bottomLeftRadius, _bottomRightRadius);
			} else if(_radius) {
				graphics.drawRoundRectComplex(0, 0, width, height, _radius, _radius, _radius, _radius);
			} else {
				graphics.drawRect(0,0, width, height);
			}
			endDraw();
		}
	}
}