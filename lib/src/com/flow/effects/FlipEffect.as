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
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	
	public class FlipEffect extends Effect {
		[Embed(source='pixelbender/flip.pbj', mimeType='application/octet-stream')]
		private var PixelatePbj:Class;
		private var shader:Shader;
		private var filter:ShaderFilter;
		
		public function FlipEffect(target:DisplayObject = null){
			super(target);
			shader = new Shader(new PixelatePbj());
			filter = new ShaderFilter(shader);
		}
		
		override protected function render(val:Number):Array {	
			var bmp:BitmapData = new BitmapData(_target.width, _target.height, true, 0);
			if(val) {
				shader.data.src1.input = bmp;
				shader.data.src2.input = bmp;
				shader.data.size.value = [_target.width+1, _target.height+1];
				shader.data.borderThickness.value = [3];
				shader.data.borderColor.value = [1.0, 1.0, 1.0];
				shader.data.phase.value = [val];
				return new Array(filter);
			} else {
				return new Array();
			}
		}	
	}
}