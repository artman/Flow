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

package com.flow.components.graphics.fills {
	
	import com.flow.components.graphics.GradientData;
	import com.flow.events.InvalidationEvent;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;

	[DefaultProperty("colors")]
	public class GradientFill extends EventDispatcher implements IFill {
		protected var _colors:Vector.<GradientData>;
		protected var _data:String;
		protected var _matrix:Matrix;
		protected var _rotation:Number = 0;
		protected var _width:Number;
		protected var _height:Number;
		
		public var type:String = GradientType.LINEAR;
		protected var gradientColors:Array;
		protected var gradientAlphas:Array;
		protected var gradientRatios:Array;
				
		public function GradientFill() {
		}
		
		public function get colors():Vector.<GradientData> {
			return _colors;
		}
		public function set colors(value:Vector.<GradientData>):void {
			if(value != _colors) {
				_colors = value;
				
				gradientColors = new Array();
				gradientAlphas = new Array();
				gradientRatios = new Array();
				
				var item:GradientData;
				for each (item in colors) {
					gradientColors.push(item.color);
					gradientAlphas.push(item.alpha);
					gradientRatios.push(item.ratio * 255);
				}
				invalidate();
			}
		}
		
		public function get matrix():Matrix {
			return _matrix;
		}
		public function set matrix(value:Matrix):void  {
			if(value != _matrix) {
				_matrix = value;
				invalidate();
			}
		}
		
		public function get rotation():Number {
			return _rotation
		}	
		public function set rotation(value:Number):void {
			if(value != _rotation) {
				_rotation = value;
				invalidate();
			}
		}	
		
		public function beginDraw(graphics:Graphics, width:int, height:int):void {		
			if (!_matrix) {
				_matrix = new Matrix();
			}
			var r:Number = _rotation * (Math.PI/180);
			_matrix.createGradientBox(width, height, r);
			graphics.beginGradientFill(type, gradientColors, gradientAlphas, gradientRatios, _matrix);
		}
		
		public function endDraw(graphics:Graphics):void  {
			graphics.endFill();
		}
		
		private function invalidate():void {
			dispatchEvent(new InvalidationEvent(InvalidationEvent.INVALIDATE));
		}
	}
}