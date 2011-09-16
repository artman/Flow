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
	
	import com.flow.events.InvalidationEvent;
	import com.flow.motion.IAnimateable;
	
	import flash.events.EventDispatcher;

	public class GradientData extends EventDispatcher implements IAnimateable {
		
		private var _color:int;
		private var _alpha:Number;
		private var _ratio:Number;
		
		public function GradientData(color:int = 0, alpha:Number = 1, ratio:Number = 0){
			this.color = color;
			this.alpha = alpha;
			this.ratio = ratio;
		}
		
		[Animateable(type="color")]
		public function get color():int {
			return _color;
		}
		public function set color(value:int):void {
			if(value != _color){
				_color = value;
				invalidate();
			}
		}
		
		[Animateable]
		public function get alpha():Number {
			return _alpha;
		}
		public function set alpha(value:Number):void {
			if(value != _alpha){
				_alpha = value;
				invalidate();
			}
		}

		[Animateable]
		public function get ratio():Number {
			return _ratio;
		}
		public function set ratio(value:Number):void {
			if(value != _ratio) {
				_ratio = value;
				invalidate();
			}
		}
		
		private function invalidate():void {
			dispatchEvent(new InvalidationEvent(InvalidationEvent.INVALIDATE));
		}
	}
}