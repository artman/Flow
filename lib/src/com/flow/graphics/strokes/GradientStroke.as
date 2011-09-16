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

package com.flow.graphics.strokes {
	
	import com.flow.events.InvalidationEvent;
	import com.flow.graphics.GradientData;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;

	[DefaultProperty("colors")]
	[Event(name="invalidate", type="com.flow.events.InvalidationEvent")]
	public class GradientStroke extends StrokeBase {
		
		protected var _colors:Vector.<GradientData>;
		protected var _data:String;
		protected var _matrix:Matrix;
		protected var _rotation:Number = 0;
		protected var _width:Number;
		protected var _height:Number;
		
		private var _type:String = GradientType.LINEAR;

		protected var gradientColors:Array;
		protected var gradientAlphas:Array;
		protected var gradientRatios:Array;
		
		public function GradientStroke() {
			super();
		}
		
		public function get colors():Vector.<GradientData> {
			return _colors;
		}
		public function set colors(value:Vector.<GradientData>):void {
			if(value != _colors) {
				if(_colors) {
					for each (var item:GradientData in colors) {
						item.removeEventListener(InvalidationEvent.INVALIDATE, invalidate);
					}
				}
				_colors = value;
				
				gradientColors = new Array();
				gradientAlphas = new Array();
				gradientRatios = new Array();
		
				for each (item in colors) {
					item.addEventListener(InvalidationEvent.INVALIDATE, invalidate);
					gradientColors.push(item.color);
					gradientAlphas.push(item.alpha);
					gradientRatios.push(item.ratio * 255);
				}
				invalidate();
			}
		}
		
		public function get matrix():Matrix  {
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
		public function set rotation(value:Number):void  {
			if(value != _rotation) {
				_rotation = value;
				invalidate();
			}
		}
		
		[Inspectable(enumeration="linear,radial", defaultValue="linear")]
		public function get type():String {
			return _type;
		}
		public function set type(value:String):void {
			if(value != _type) {
				_type = value;
				invalidate();
			}
		}
		
		override public function beginDraw(graphics:Graphics, width:int, height:int):void {
			if (!_matrix) {
				_matrix = new Matrix();
			}
			var r:Number = _rotation * (Math.PI/180);
			_matrix.createGradientBox(width, height, r);
			graphics.lineStyle(_thickness, 0, 1, true, "normal", _caps, _joints, _miterLimit);
			graphics.lineGradientStyle(_type, gradientColors, gradientAlphas, gradientRatios, _matrix);
		}
	}
}