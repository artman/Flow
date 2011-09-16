/**
 * Copyright (c) 2011 Tuomas Artman, http://artman.fi, PJB by Justin Everett-Church
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
	
	public class ChihulyEffect extends Effect {
		[Embed(source='pixelbender/chihuly.pbj', mimeType='application/octet-stream')]
		private var ChihulyPbj:Class;
  		private var shader:Shader;
  		private var filter:ShaderFilter;
		
  		private var _height:int;
		private var _stemScale:Number;
		private var _squiggleScale:Number;
		
		public function ChihulyEffect(target:DisplayObject = null, height:int = 60, stemScale:Number = 1.3, squiggleScale:Number = 3.0){
			super(target);
			_height = height;
			_stemScale = stemScale;
			_squiggleScale = squiggleScale;
			shader = new Shader(new ChihulyPbj());
			filter = new ShaderFilter(shader);
		}
		
		public function get height():int {
			return _height;
		}
		public function set height(value:int):void {
			if(value != _height) {
				_height = value;
				invalidate();
			}
		}
		
		public function get stemScale():Number {
			return _stemScale;
		}
		public function set stemScale(value:Number):void {
			if(value != _stemScale) {
				_stemScale = value;
				invalidate();
			}
		}

		public function get squiggleScale():Number {
			return _squiggleScale;
		}
		public function set squiggleScale(value:Number):void {
			if(value != _squiggleScale) {
				_squiggleScale = value;
				invalidate();
			}
		}

		

		override protected function render(val:Number):Array {
			if(val) {
				shader.data.line.value = [-height + (_target.height + height)*(1-val)];
				shader.data.height.value = [height];
				shader.data.stemScale.value = [stemScale];
				shader.data.squiggleScale = [squiggleScale];
				return new Array(filter);
			} else {
				return new Array();
			}
		}	
	}
}