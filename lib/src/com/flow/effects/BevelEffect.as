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
	import flash.filters.BevelFilter;

	public class BevelEffect extends Effect {
		
		protected var filter:BevelFilter;
		private var _distance:Number;
		private var _angle:Number;
		private var _highlightColor:Number;
		private var _highlightAlpha:Number;
		private var _shadowColor:Number;
		private var _shadowAlpha:Number;
		private var _blurX:Number;
		private var _blurY:Number;
		private var _strength:Number;
		private var _bevelQuality:Number;

		public function BevelEffect(target:DisplayObject = null, distance:Number = 4, angle:Number = 90, highlightColor:int = 0xFFFFFF, highlightAlpha:Number = 0.3, shadowColor:int = 0, shadowAlpha:Number = 0.3, blurX:Number = 5, blurY:Number = 5, strength:Number = 2, bevelQuality:Number = 1){
			super(target);
			_distance = distance;
			_angle = angle;
			_highlightColor = highlightColor;
			_highlightAlpha= highlightAlpha;
			_shadowColor= shadowColor;
			_shadowAlpha= shadowAlpha;
			_blurX= blurX;
			_blurY= blurY;
			_strength= strength;
			_bevelQuality = bevelQuality;
		}	
		
		override protected function validateProperties():void {
			this.filter = new BevelFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, bevelQuality)
		}
		
		public function get distance():Number {
			return _distance;
		}
		public function set distance(value:Number):void {
			if(value != _distance) {
				_distance = value;
				invalidateProperties();
			}
		}
		
		public function get angle():Number {
			return _angle;
		}
		public function set angle(value:Number):void {
			if(value != _angle) {
				_angle = value;
				invalidateProperties();
			}
		}
		
		public function get highlightColor():Number {
			return _highlightColor;
		}
		public function set highlightColor(value:Number):void {
			if(value != _highlightColor) {
				_highlightColor = value;
				invalidateProperties();
			}
		}

		public function get highlightAlpha():Number {
			return _highlightAlpha;
		}
		public function set highlightAlpha(value:Number):void {
			if(value != _highlightAlpha) {
				_highlightAlpha = value;
				invalidateProperties();
			}
		}

		public function get shadowColor():Number {
			return _shadowColor;
		}
		public function set shadowColor(value:Number):void {
			if(value != _shadowColor) {
				_shadowColor = value;
				invalidateProperties();
			}
		}

		public function get shadowAlpha():Number {
			return _shadowAlpha;
		}
		public function set shadowAlpha(value:Number):void {
			if(value != _shadowAlpha) {
				_shadowAlpha = value;
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

		public function get strength():Number {
			return _strength;
		}
		public function set strength(value:Number):void {
			if(value != _strength) {
				_strength = value;
				invalidateProperties();
			}
		}

		public function get bevelQuality():Number {
			return _bevelQuality;
		}
		public function set bevelQuality(value:Number):void {
			if(value != _bevelQuality) {
				_bevelQuality = value;
				invalidateProperties();
			}
		}

		override protected function render(val:Number):Array{
			filter.strength = strength * val;
			
			if(val) {
				return new Array(filter);
			} else {
				return new Array();
			}
		}
	}
}