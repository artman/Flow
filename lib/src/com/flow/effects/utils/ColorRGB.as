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

	/**
	 * A class representing a RGB color value.
	 */	
	public class ColorRGB {
		
		/**
		 * The red component of the color. 
		 */		
		public var r:uint;
		
		/**
		 * The green component of the color. 
		 */		
		public var g:uint;
		
		/**
		 * The blue component of the color. 
		 */		
		public var b:uint;
		
		/**
		 * Constructor 
		 * @param The color to create the instance from.
		 */		
		public function ColorRGB(color:uint = 0) {
			this.color = color;
		}
		
		/**
		 * Parse a color string. 
		 * @param The string to parse. This must be a hex-string and can begin (but does not have to) with "#" or "0x".
		 */		
		public function parseString(string:String):void {
			if(string.length == 7 && string.indexOf("#") == 0){
				string = string.substr(1,6);
				color = int(string);
			} else if(string.length == 8 && string.indexOf("0x") == 0) {
				color = int(string);
			} else if (string.length == 6){
				color = int(string);
			} else {
				color = 0;
			}
		}
		
		/**
		 * The uint value for the color.
		 */		
		public function get color():uint {
			return r << 16 | g << 8 | b;
		}
		public function set color(value:uint):void {
			r = value >> 16 & 0xFF;
			g = value >> 8 & 0xFF;
			b = value & 0xFF;
		}
		
		/**
		 * Returns a new color that comes from mixing the instance with another color.
		 * @param The color to mix with the color represented by the instance.
		 * @param The amount (0-1) at which to use the new color.
		 * @return The mixed color.
		 */		
		public function mix(color:ColorRGB, amount:Number):ColorRGB {
			var ret:ColorRGB = new ColorRGB();
			ret.r = r + (color.r-r) * amount;
			ret.g = g + (color.g-g) * amount;
			ret.b = b + (color.b-b) * amount;
			return ret;
		}
		
		/**
		 * Duplicates the color.
		 */		
		public function duplicate():ColorRGB {
			return new ColorRGB(color);
		}
		
		/**
		 * Uses the color to colorize a DisplayObject. 
		 * @param The DisplayObject to colorize.
		 */		
		public function colorizeDisplayObject(displayObject:DisplayObject):void {
			var colorTransform:ColorTransform = new ColorTransform(0, 0, 0, 1, r, g, b);
			displayObject.transform.colorTransform = colorTransform;
		}
	}
}