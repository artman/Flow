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

package com.flow.components.measuring {
	public class MeasureUnit {
		
		public var value:Number = 0;
		public var isPercentage:Boolean = false;
		public var isNull:Boolean = true;
		
		public function MeasureUnit(value:*) {
			parse(value);
		}
		
		public function parse(value:*):void {
			if(value is String || value is Number || value is int) {
				isNull = false;
				if(value is String && (value as String).indexOf("%") > 0) {
					isPercentage = true;
					value = (value as String).replace("%", "");
				} else {
					isPercentage = false;
				}
				this.value = Number(value);
			} else {
				this.value = 0;
				isPercentage = false;
				isNull = true;
			}
		}
		
		public function get unit():* {
			if(isNull) {
				return null;
			}
			if(isPercentage) {
				return value + "%";
			}
			return value;
		}
	}
}