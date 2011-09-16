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
	
	import com.flow.graphics.fills.SolidFill;
	
	import flash.geom.Point;
	
	/**
	 * A base class for drawing shapes. 
	 */	
	[DefaultProperty("points")]
	public class Shape extends Geometry {
		
		private var _points:Vector.<Point>;
		private var _flipHorizontal:Boolean = false;
		
		/**
		 * Constructor 
		 */		
		public function Shape() {
			fill = new SolidFill();
		}
		
		/**
		 * A list of points to draw 
		 */		
		public function get points():Vector.<Point> {
			return _points;
		}
		public function set points(value:Vector.<Point>):void {
			if(value != _points) {
				_points = value;
				invalidateLayout();
			}
		}
		
		/**
		 * Whether to flip all points horizontally (default false). 
		 */		
		public function get flipHorizontal():Boolean {
			return _flipHorizontal;
		}
		public function set flipHorizontal(value:Boolean):void {
			if(value != _flipHorizontal) {
				_flipHorizontal = value;
				invalidate();
			}
		}
		
		/** @private */
		override public function measure():void {
			var maxW:Number = 0;
			var maxH:Number = 0;
			if(_points) {
				for(var i:int = 0; i<_points.length; i++) {
					var pnt:Point = _points[i];
					maxW = pnt.x > maxW ? pnt.x : maxW;
					maxH = pnt.y > maxH ? pnt.y : maxH;
				}
			}
			measuredWidth = maxW;
			measuredHeight = maxH;
		}
		
		/** @private */		
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
			if(_points) {
				var mulX:int = 1;
				var mulY:int = 1;
				var oX:int = 0;
				var oY:int = 0;
				if(_flipHorizontal) {
					oX = width;
					mulX = -1;
				}
				graphics.moveTo(_points[0].x*mulX+oX, _points[0].y*mulY+oY);
				var length:int = _points.length;
				for(var i:int = 1; i<length; i++) {
					var pnt:Point = _points[i];
					graphics.lineTo(pnt.x*mulX+oX, pnt.y*mulY+oY);
				}
			}
			endDraw();
		}
		
	}
}