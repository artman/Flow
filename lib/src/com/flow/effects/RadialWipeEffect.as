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
	import flash.geom.Matrix;

	public class RadialWipeEffect extends MaskFilterEffect {
		
		private var _feather:Number;

		public function RadialWipeEffect(target:DisplayObject = null, feather:Number = 10, bounds:int = 0){
			super(target, bounds);
			this.feather = feather;
			if(this.feather < 2) {
				this.feather = 2;
			}
		}
		
		public function get feather():Number {
			return _feather;
		}

		public function set feather(value:Number):void {
			if(value != _feather) {
				_feather = value;
				invalidate();
			}
		}

		override protected function renderMask(val:Number, bnds:Object):void {
			maskSprite.graphics.clear();
			maskSprite.graphics.lineStyle(undefined);
			
			var fillType:String = "radial"
			var colors:Array = [0xFF0000, 0xFF0000];
			var alphas:Array = [100, 0];
			var ratios:Array = [64, Math.min(64 + feather, 255)];
			var matrix:Matrix = new Matrix();
			
			var aspect:Number = bnds.width / bnds.height;
			var m:Number = 1.35;
			
			if(aspect>1){
				m = 1.35*aspect;
			}
			
			if(val==1) {
				val = 0.9999999;
			}
			var sizeX:Number = (1-val)*400*m /aspect;
			var offsetX:Number = 50 - ((1-val)*200*m) / aspect;
			var sizeY:Number = (1-val)*400*m;
			var offsetY:Number = 50 - (1-val)*200*m;
			
			matrix.createGradientBox(sizeX, sizeY, 0, offsetX, offsetY);
			var spreadMethod:String = "pad";
			maskSprite.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod); 
			maskSprite.graphics.lineTo(100, 0);
			maskSprite.graphics.lineTo(100, 100);
			maskSprite.graphics.lineTo(0, 100);
			maskSprite.graphics.lineTo(0, 0);
			maskSprite.graphics.endFill();
		}
	}
}