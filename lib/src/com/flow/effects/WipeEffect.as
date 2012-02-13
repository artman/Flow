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

	public class WipeEffect extends MaskFilterEffect {
		
		private var _smooth:Number;
		private var _angle:Number;
	
		public function WipeEffect(target:DisplayObject = null, angle:Number = 0, smooth:Number = 50, bounds:Number = 5):void{
			super(target, bounds);
			this.smooth = smooth;
			_angle = angle;
		}

		[Animateable]
		public function get smooth():Number {
			return _smooth;
		}
		public function set smooth(value:Number):void {
			if(value != _smooth) {
				_smooth = Math.max(value, 2);
				invalidate();
			}
		}

		[Animateable]
		public function get angle():Number {
			return _angle;
		}
		public function set angle(value:Number):void {
			if(value != _angle) {
				_angle = value;
				invalidate();
			}
		}

		override protected function renderMask(val:Number, bnds:Object):void{
			maskSprite.graphics.clear();
			
			var ang:Number = angle / 180 * Math.PI;
			
			var fillType:String = "linear"
			var colors:Array = [0xFFFF00, 0xFF0000];
			var alphas:Array = [1, 0];
			var ratios:Array = [0, 255];
			var matrix:Matrix = new Matrix();
	
			var xDis:Number = (100 + (smooth*2)) * Math.cos(ang)
			var yDis:Number = (100 + (smooth*2)) * Math.sin(ang)
				
			var xOff:Number = -smooth/2 + 50 + (smooth) * Math.sin(ang);
			var yOff:Number = -smooth/2 + 50 - (smooth) * Math.cos(ang);
				
			var delX:Number = xOff - (xDis/2) + xDis * (1-val);
			var delY:Number = yOff - (yDis/2) + yDis * (1-val);
				
			matrix.createGradientBox(smooth, smooth, ang, delX, delY);
				
			var spreadMethod:String = "pad";
			maskSprite.graphics.lineStyle(undefined);
			maskSprite.graphics.beginGradientFill(fillType, colors, alphas, ratios, matrix, spreadMethod); 
			maskSprite.graphics.lineTo(100, 0);
			maskSprite.graphics.lineTo(100, 100);
			maskSprite.graphics.lineTo(0, 100);
			maskSprite.graphics.lineTo(0, 0);
			maskSprite.graphics.endFill();
		}
	}
}