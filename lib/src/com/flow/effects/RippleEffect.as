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

package com.flow.effects{
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;

	public class RippleEffect extends Effect {
	
		private var _amount:Number;
		private var _waveLength:Number;
		private var _waveCount:int;
		private var perlinBmp:BitmapData;
		private var filter:DisplacementMapFilter;

		public function RippleEffect(target:DisplayObject = null, amount:Number = 10, waveLength:Number = 50, waveCount:int = 3){
			_amount = amount;
			_waveLength = waveLength;
			_waveCount = waveCount;
			super(target);
		}
		
		override protected function validateProperties():void {
			if(target) {
				perlinBmp = new BitmapData(target.width + 200, target.height, false, 0xFFFFFF);
				perlinBmp.perlinNoise(waveLength, waveLength, waveCount, Math.floor(Math.random() * 100), false, true, 1 | 2, false, null);
				filter = new DisplacementMapFilter(perlinBmp, new Point(0, 0), 1, 2, 10, 10, DisplacementMapFilterMode.CLAMP, 0x000000, 0x000000);
			} else {
				filter = null;
			}
		}
		
		public function get amount():Number {
			return _amount;
		}
		public function set amount(value:Number):void {
			if(value != _amount) {
				_amount = value;
				invalidateProperties();
			}
		}

		public function get waveLength():Number {
			return _waveLength;
		}
		public function set waveLength(value:Number):void {
			if(value != _waveLength) {
				_waveLength = value;
				invalidateProperties();
			}
		}

		public function get waveCount():int {
			return _waveCount;
		}
		public function set waveCount(value:int):void {
			if(value != _waveCount) {
				_waveCount = value;
				invalidateProperties();
			}
		}

		override public function set target(value:DisplayObject):void {
			super.target = value;
			invalidateProperties();
		}
		
		override protected function render(val:Number):Array{
			filter.scaleX = filter.scaleY = val * amount;
			filter.mapPoint = new Point(val * -100, 0);
			if(val) {
				return new Array(filter);
			} else {
				return new Array();
			}
		}
	}

}