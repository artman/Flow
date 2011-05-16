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
	
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	
	public class PixelateEffect extends Effect {
		[Embed(source='pixelbender/pixelate.pbj', mimeType='application/octet-stream')]
  		
		private var PixelatePbj:Class;
  		private var shader:Shader;
  		private var filter:ShaderFilter;
  		private var _amount:int;
		
		public function PixelateEffect(target:DisplayObject = null, amount:int = 20){
			super(target);
			this.amount = amount;
			shader = new Shader(new PixelatePbj());
			filter = new ShaderFilter(shader);
		}
		
		public function get amount():int {
			return _amount;
		}

		public function set amount(value:int):void {
			if(value != _amount) {
				_amount = value;
				invalidate();
			}
		}

		override protected function render(val:Number):Array {
			if(1 + Math.round(amount * val) != 1) {
				shader.data.dimension.value = [1 + Math.round(amount * val)];
				return new Array(filter);
			} else {
				return new Array();
			}
		}	
	}
}