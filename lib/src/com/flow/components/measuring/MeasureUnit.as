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
	/**
	 * A unit to measurement used by the layout-engine.
	 */	
	public class MeasureUnit {
		
		/** The value of the unit. */		
		public var value:Number = 0;
		/** Whether the value is a percentage of the parent objects dimensions. */		
		public var isPercentage:Boolean = false;
		/** Whether the unit us null. */		
		public var isNull:Boolean = true;
		
		/**
		 * Consturctor. Creates a new measure unit. 
		 * @param The value of the measure unit. Acceptably type for the value are Number, int and String. If the value is a string and
		 * contains the %-character the unit is defined to be a percentage of it's parent components dimensions.
		 */		
		public function MeasureUnit(value:*) {
			parse(value);
		}
		
		/** @private */  
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
		
		/** @private */  
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