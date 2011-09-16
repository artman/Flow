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

package com.flow.effects.utils {
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	public class ColorRGB {
		
		public var r:uint;
		public var g:uint;
		public var b:uint;
		
		public function ColorRGB(color:uint = 0) {
			this.color = color;
		}
		
		public function parseString(string:String):void {
			if(string.length == 7 && string.indexOf("#") == 0){
				string = string.substr(1,6);
				color = int(string);
			} else if(string.length == 8 && string.indexOf("0x") == 0) {
				color = int(string);
			} else {
				color = 0;
			}
		}

		public function get color():uint {
			return r << 16 | g << 8 | b;
		}
		public function set color(value:uint):void {
			r = value >> 16 & 0xFF;
			g = value >> 8 & 0xFF;
			b = value & 0xFF;
		}
	
		public function mix(color:ColorRGB, amount:Number):ColorRGB {
			var ret:ColorRGB = new ColorRGB();
			ret.r = r + (color.r-r) * amount;
			ret.g = g + (color.g-g) * amount;
			ret.b = b + (color.b-b) * amount;
			return ret;
		}

		public function duplicate():ColorRGB {
			return new ColorRGB(color);
		}
		
		public function colorizeDisplayObject(displayObject:DisplayObject):void {
			var colorTransform:ColorTransform = new ColorTransform(0, 0, 0, 1, r, g, b);
			displayObject.transform.colorTransform = colorTransform;
		}
	}
}