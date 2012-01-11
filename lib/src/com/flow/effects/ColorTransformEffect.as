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
	
	/**
	 * Creates a color transform effect. 
	 */	
	public class ColorTransformEffect extends Effect {
		
		private var filter:ColorMatrixFilter;
		private var color:ColorRGB;
		private var multiply:Number;
		private var _transform:ColorTransform;
		
		public function ColorTransformEffect(target:DisplayObject = null, transform:ColorTransform = null){
			this.transform = transform
			super(target);
		}
		
		public function copyTransform(displayObject:DisplayObject):void {
			transform = displayObject.transform.colorTransform;
		}
		
		public function get transform():ColorTransform {
			return _transform;
		}
		
		public function set transform(value:ColorTransform):void {
			if(value != _transform) {
				_transform = value;
				invalidate();
			}
		}

		override protected function render(val:Number):Array {
			if(_transform) {
				var tr:ColorTransform = new ColorTransform();
				
				tr.redMultiplier = _transform.redMultiplier * val;
				tr.greenMultiplier = _transform.greenMultiplier * val;
				tr.blueMultiplier = _transform.blueMultiplier * val;
				tr.alphaMultiplier = _transform.alphaMultiplier * val;
				
				tr.redOffset = _transform.redOffset * val;
				tr.greenOffset = _transform.greenOffset * val;
				tr.blueOffset = _transform.blueOffset * val;
				tr.alphaOffset = _transform.alphaOffset * val;
				
				_target.transform.colorTransform = tr;
			}
			return new Array();
		}
	}
}