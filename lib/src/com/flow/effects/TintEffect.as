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

package com.flow.effects {
	
	import com.flow.effects.utils.ColorRGB;
	
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	public class TintEffect extends Effect {
		
		private var filter:ColorMatrixFilter;
		private var _color:ColorRGB;
		private var _multiply:Number;
		
		public function TintEffect(target:DisplayObject = null, color:uint = 0, multiply:Number = 1){
			_color = new ColorRGB(color);
			_multiply = multiply
			super(target);
		}
		
		[Animateable(type="color")]
		public function get color():int {
			return _color.color;
		}
		public function set color(value:int):void {
			if(value != _color.color) {
				_color.color = value;
				invalidate();
			}
		}

		[Animateable]
		public function get multiply():Number {
			return _multiply;
		}
		public function set multiply(value:Number):void {
			if(value != _multiply) {
				_multiply = value;
				invalidate();
			}
		}

		override protected function render(val:Number):Array {
			var transform:ColorTransform = new ColorTransform();
			var val:Number = _multiply * value;
			
			transform.redMultiplier = 1-val;
			transform.greenMultiplier = 1-val;
			transform.blueMultiplier = 1-val;

			transform.redOffset = _color.r * val;
			transform.greenOffset = _color.g * val;
			transform.blueOffset = _color.b * val;
			_target.transform.colorTransform = transform;
			
			return new Array();
		}
	}
}