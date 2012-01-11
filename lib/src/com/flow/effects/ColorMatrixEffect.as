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
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * Creates a color matrix effect that lets you apply colorization effects to a target display object. 
	 */	
	public class ColorMatrixEffect extends Effect {
	
		private var _matrix:Array;
		private var defaultMatrix:Array;
		private var changedMatrix:Array;
		private var filter:ColorMatrixFilter;
		
		/**
		 * Constructor. 
		 * @param The target to colorize.
		 * @param The ColorMatrix to apply to the target object. You ca easily create these with the ColorMatrix util.
		 * @see com.flow.effects.utils.ColorMatrix
		 */		
		public function ColorMatrixEffect(target:DisplayObject = null, matrix:Array = null){
			this.matrix = matrix;
			super(target);
			defaultMatrix = [1,0,0,0,0,  
							 0,1,0,0,0,  
							 0,0,1,0,0,  
							 0,0,0,1,0];
			filter = new ColorMatrixFilter(_matrix);
		}
		
		/**
		 * The ColorMatrix to apply to the target object.
		 */		
		public function get matrix():Array {
			return _matrix;
		}
		public function set matrix(value:Array):void{
			if(value != _matrix) {
				_matrix = value;
				invalidate();
			}
		}
		
		/** @private */
		override protected function render(val:Number):Array{
			changedMatrix = _matrix.concat();
			for(var i:int = 0; i<20; i++) {
				changedMatrix[i] = defaultMatrix[i] + (changedMatrix[i] - defaultMatrix[i]) * val;
			}
			filter.matrix = changedMatrix;
			if(val) {
				return new Array(filter);
			} else {
				return new Array();
			}
		}
	}
}