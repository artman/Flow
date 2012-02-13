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
	
	import com.flow.effects.utils.ColorMatrix;
	
	import flash.display.DisplayObject;

	public class CSBEffect extends ColorMatrixEffect {
	
		private var _contrast:Number;
		private var _saturation:Number;
		private var _brightness:Number;
		
		public function CSBEffect(target:DisplayObject = null, contrast:Number = 0, saturation:Number = 0, brightness:Number = 0){
			_contrast = contrast;
			_saturation = saturation;
			_brightness = brightness;
			validateProperties();
			super(target, this.matrix);
		}
		
		override protected function validateProperties():void {
			var colConv:ColorMatrix = new ColorMatrix();
			colConv.adjustSaturation(saturation);
			colConv.adjustBrightness(brightness);
			colConv.adjustContrast(contrast);
			matrix = colConv.toArray();
		}
		
		[Animateable]
		public function get contrast():Number {
			return _contrast;
		}
		public function set contrast(value:Number):void {
			if(value != _contrast) {
				_contrast = value;
				invalidateProperties();
			}
		}

		[Animateable]
		public function get saturation():Number {
			return _saturation;
		}
		public function set saturation(value:Number):void {
			if(value != _saturation) {
				_saturation = value;
				invalidateProperties();
			}
		}

		[Animateable]
		public function get brightness():Number {
			return _brightness;
		}
		public function set brightness(value:Number):void {
			if(value != _brightness) {
				_brightness = value;
				invalidateProperties();
			}
		}

	}
}
