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
	import flash.filters.GlowFilter;	

	public class GlowEffect extends Effect {
		
		protected var filter:GlowFilter;
		private var _color:Number;
		private var _alpha:Number;
		private var _quality:Number;
		private var _blurX:Number;
		private var _blurY:Number;
		private var _strength:Number;

		public function GlowEffect(target:DisplayObject = null, color:Number = 0xFF0000, alpha:Number = 1, blurX:Number = 20, blurY:Number = 20, strength:Number = 4, quality:Number = 1) {
			super(target);
			_color = color;
			_alpha = alpha;
			_blurX = blurX;
			_blurY = blurY;
			_strength = strength;
			_quality = quality;
		}	
		
		override protected function validateProperties():void {
			filter = new GlowFilter(_color, alpha, _blurX, _blurY, _strength, _quality);
		}
		
		[Animateable(type="color")]
		public function get color():Number {
			return _color;
		}
		public function set color(value:Number):void {
			if(value != _color) {
				_color = value;
				invalidateProperties();
			}
		}

		[Animateable]
		public function get alpha():Number {
			return _alpha;
		}
		public function set alpha(value:Number):void {
			if(value != _alpha) {
				_alpha = value;
				invalidateProperties();
			}
		}

		public function get glowQuality():Number {
			return _quality;
		}
		public function set glowQuality(value:Number):void {
			if(value != _quality) {
				_quality = value;
				invalidateProperties();
			}
		}

		[Animateable]
		public function get blurX():Number {
			return _blurX;
		}
		public function set blurX(value:Number):void {
			if(value != _blurX) {
				_blurX = value;
				invalidateProperties();
			}
		}
		
		[Animateable]
		public function get blurY():Number {
			return _blurY;
		}
		public function set blurY(value:Number):void {
			if(value != _blurY) {
				_blurY = value;
				invalidateProperties();
			}
		}

		[Animateable]
		public function get strength():Number {
			return _strength;
		}
		public function set strength(value:Number):void {
			if(value != _strength) {
				_strength = value;
				invalidateProperties();
			}
		}

		override protected function render(val:Number):Array {
			filter.color = color;
			filter.alpha = alpha*val;
			filter.blurX = blurX;
			filter.blurY = blurY;
			filter.strength = strength*val;
			filter.quality = glowQuality;

			if(val) {
				return new Array(filter);
			} else {
				return new Array();
			}
		}
	}
}