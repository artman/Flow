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
	
	public class FullBevelEffect extends BevelEffect {
		
		public function FullBevelEffect(target:DisplayObject = null, distance:Number = 3, angle:Number = 45, highlightColor:int = 0xFFFFFF, highlightAlpha:Number = 0.5, shadowColor:int = 0, shadowAlpha:Number = 0.5, blurX:Number = 5, blurY:Number = 5, strength:Number = 3, bevelQuality:Number = 1){
			super(target, distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, bevelQuality);
		}
		
		override protected function validateProperties():void {
			super.validateProperties();
			filter.type = "full";
		}
	}
}