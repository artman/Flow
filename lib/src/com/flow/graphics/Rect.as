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
	
	import flash.display.Graphics;
	
	/**
	 * A simple rectangle that can have rounder corners. 
	 */	
	[DefaultProperty("fill")]
	public class Rect extends Geometry {
		
		private var _radius:Number = 0;
		private var _topLeftRadius:Number = 0;
		private var _topRightRadius:Number = 0;
		private var _bottomLeftRadius:Number = 0;
		private var _bottomRightRadius:Number = 0;
		
		/**
		 * Constructor .
		 */		
		public function Rect() {
			super();
			stroke = null;
		}
		
		/**
		 * The radius of the rectangle's corners.
		 * 
		 * This property is animateable.
		 */		
		[Animateable]
		public function get radius():Number {
			return _radius;
		}
		public function set radius(value:Number):void {
			if(value != _radius) {
				_radius = value;
				invalidate();
			}
		}
		
		/**
		 * The radius of the top left corner of the rectangle. If this is set, the radius-property will be ingored.
		 * 
		 * This property is animateable.
		 */		
		[Animateable]
		public function get topLeftRadius():Number {
			return _topLeftRadius;
		}
		public function set topLeftRadius(value:Number):void {
			if(value != _topLeftRadius) {
				_topLeftRadius = value;
				invalidate();
			}
		}
		
		/**
		 * The radius of the top right corner of the rectangle. If this is set, the radius-property will be ingored.
		 * 
		 * This property is animateable.
		 */	
		[Animateable]
		public function get topRightRadius():Number {
			return _topRightRadius;
		}
		public function set topRightRadius(value:Number):void {
			if(value != _topRightRadius) {
				_topRightRadius = value;
				invalidate();
			}
		}
		
		/**
		 * The radius of the bottom left corner of the rectangle. If this is set, the radius-property will be ingored.
		 * 
		 * This property is animateable.
		 */	
		[Animateable]
		public function get bottomLeftRadius():Number {
			return _bottomLeftRadius;
		}
		public function set bottomLeftRadius(value:Number):void {
			if(value != _bottomLeftRadius) {
				_bottomLeftRadius = value;
				invalidate();
			}
		}
		
		/**
		 * The radius of the bottom right corner of the rectangle. If this is set, the radius-property will be ingored.
		 * 
		 * This property is animateable.
		 */	
		[Animateable]
		public function get bottomRightRadius():Number {
			return _bottomRightRadius;
		}
		public function set bottomRightRadius(value:Number):void {
			if(value != _bottomRightRadius) {
				_bottomRightRadius = value;
				invalidate();
			}
		}
		
		/** @private */
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
			
			if (_topLeftRadius || _topRightRadius || _bottomRightRadius || _bottomLeftRadius) {
				drawRoundedRect(graphics, 0, 0, width, height, _topLeftRadius, _topRightRadius, _bottomRightRadius, _bottomLeftRadius);
				//graphics.drawRoundRectComplex(0, 0, width, height, _topLeftRadius, _topRightRadius, _bottomLeftRadius, _bottomRightRadius);
			} else if(_radius) {
				drawRoundedRect(graphics, 0, 0, width, height, _radius, _radius, _radius, _radius);
				//graphics.drawRoundRectComplex(0, 0, width, height, _radius, _radius, _radius, _radius);
			} else {
				graphics.drawRect(0,0, width, height);
			}
			endDraw();
		}
		
		private function drawRoundedRect(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, tl:Number, tr:Number, br:Number, bl:Number):void {
			graphics.moveTo(tl, 0);
			graphics.lineTo(width - tl, 0);
			graphics.curveTo(width, 0, width, tr);
			graphics.lineTo(width, height - br);
			graphics.curveTo(width, height, width - br, height);
			graphics.lineTo(bl, height);
			graphics.curveTo(0, height, 0, height - bl);
			graphics.lineTo(0, tl);
			graphics.curveTo(0, 0, tl, 0);
		}
	}
}