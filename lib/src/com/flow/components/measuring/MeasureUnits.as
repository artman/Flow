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
	 * A collection of measure units that can be accessed using the measeureUnits property of a Component. Accessing these is faster
	 * than to access all the measure units individually. A MeasureUnits instance is usually used in a Layout-class.
	 * @author artman
	 * @see MeasureUnit
	 */	
	public class MeasureUnits {
		/** The MeasureUnit for the top property. */		
		public var top:MeasureUnit;
		/** The MeasureUnit for the bottom property. */
		public var bottom:MeasureUnit;
		/** The MeasureUnit for the left property. */
		public var left:MeasureUnit;
		/** The MeasureUnit for the right property. */
		public var right:MeasureUnit;
		/** The MeasureUnit for the width property. */
		public var w:MeasureUnit;
		/** The MeasureUnit for the height property. */
		public var h:MeasureUnit;
		/** The MeasureUnit for the verticalCenter property. */
		public var verticalCenter:MeasureUnit;
		/** The MeasureUnit for the horizontalCenter property. */
		public var horizontalCenter:MeasureUnit;
		
		/**
		 * Constructor. You never need to instantiate this class directly. 
		 */		
		public function MeasureUnits() {
		}
	}
}