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
	import flash.filters.DropShadowFilter;
	
	public class DropShadowEffect extends Effect {
		
		protected var filter:DropShadowFilter;
		private var _distance:Number;
		private var _angle:Number;
		private var _color:Number;
		private var _alpha:Number;
		private var _blurX:Number;
		private var _blurY:Number;
		private var _strength:Number;
		private var _quality:int;
		private var _inner:Boolean;
		private var _knockout:Boolean;
		private var _hideObject:Boolean;
		
		public function DropShadowEffect(target:DisplayObject = null, distance:Number = 2, angle:Number = 90, color:Number = 0, alpha:Number = 1, blurX:Number = 5, blurY:Number = 5, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false){
			super(target);
			_distance=distance;
			_angle=angle;
			_color=color;
			_alpha=alpha;
			_blurX=blurX;
			_blurY=blurY;
			_strength = strength;
			_quality = quality;
			_inner = inner;
			_knockout = knockout;
			_hideObject = hideObject;
		}	
		
		override protected function validateProperties():void {
			filter = new DropShadowFilter(_distance, _angle, _color, _alpha, _blurX, _blurY, _strength, _quality, _inner, _knockout, _hideObject);
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

		public function get color():Number {
			return _color;
		}
		public function set color(value:Number):void {
			if(value != _color) {
				_color = value;
				invalidateProperties();
			}
		}

		public function get alpha():Number {
			return _alpha;
		}
		public function set alpha(value:Number):void {
			if(value != _alpha) {
				_alpha = value;
				invalidate();
			}
		}

		public function get blurX():Number {
			return _blurX;
		}
		public function set blurX(value:Number):void {
			if(value != _blurX) {
				_blurX = value;
				invalidate();
			}	
		}

		public function get blurY():Number {
			return _blurY;
		}
		public function set blurY(value:Number):void {
			if(value != _blurY) {
				_blurY = value;
				invalidate();
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
		
		public function get quality():Number {
			return _quality;
		}
		public function set quality(value:Number):void {
			if(value != _quality) {
				_quality = value;
				invalidateProperties();
			}
		}
		
		public function get inner():Boolean {
			return _inner;
		}
		public function set inner(value:Boolean):void {
			if(value != _inner) {
				_inner = value;
				invalidateProperties();
			}
		}
		
		public function get knockout():Boolean {
			return _knockout;
		}
		public function set knockout(value:Boolean):void {
			if(value != _knockout) {
				_knockout = value;
				invalidateProperties();
			}
		}
		
		public function get hideObject():Boolean {
			return _hideObject;
		}
		public function set hideObject(value:Boolean):void {
			if(value != _hideObject) {
				_hideObject = value;
				invalidateProperties();
			}
		}
	
		override protected function render(val:Number):Array{
			filter.alpha = alpha*val;
			filter.blurX = blurX*val;
			filter.blurY = blurY*val;

			if(val) {
				return new Array(filter);
			} else {
				return new Array();
			}
		}
		
		public function update():void{
			render(0);
		}
	}
}