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
	import flash.filters.BlurFilter;

	public class BlurEffect extends Effect {
		
		private var filter:BlurFilter;
		private var _blurQuality:Number;
		private var _blurX:Number;
		private var _blurY:Number;

		public function BlurEffect(target:DisplayObject = null, blurX:Number = 10, blurY:Number = 10, blurQuality:Number = 1){
			super(target);
			_blurX = blurX;
			_blurY = blurY;
			_blurQuality = blurQuality;
		}	
		
		override protected function validateProperties():void {
			filter = new BlurFilter(_blurX, _blurY, _blurQuality);
		}
		
		public function get blurQuality():Number {
			return _blurQuality;
		}
		public function set blurQuality(value:Number):void {
			if(value != _blurQuality) {
				_blurQuality = value;
				invalidateProperties();
			}
		}

		public function get blurX():Number {
			return _blurX;
		}
		public function set blurX(value:Number):void {
			if(value != _blurX) {
				_blurX = value;
				invalidateProperties();
			}
		}

		public function get blurY():Number {
			return _blurY;
		}
		public function set blurY(value:Number):void {
			if(value != _blurY) {
				_blurY = value;
				invalidateProperties();
			}
		}

		override protected function render(val:Number):Array{
			filter.blurX = blurX*val;
			filter.blurY = blurY*val;
			filter.quality = blurQuality;
			if(val) {
				return new Array(filter);
			} else {
				return new Array();
			}
		}
	}

}