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

package com.flow.containers.layout {
	
	/**
	 * A collection of static variables used to describe how layouts should align their children. 
	 */	
	public class AlignType {
		
		/**
		 * A static constant describing the vertical top-alignment. 
		 */
		public static const ALIGN_TOP:String = "top";
		
		/**
		 * A static constant describing the vertical middle-alignment. 
		 */		
		public static const ALIGN_MIDDLE:String = "middle";	
		
		/**
		 * A static constant describing the vertical bottom-alignment. 
		 */		
		public static const ALIGN_BOTTOM:String = "bottom";
		
		/**
		 * A static constant describing no alignment
		 */		
		public static const ALIGN_NONE:String = "none";
		
		/**
		 * A static constant describing the horizontal left-alignment. 
		 */		
		public static const ALIGN_LEFT:String = "left";
		
		/**
		 * A static constant describing the horizontal center-alignment. 
		 */	
		public static const ALIGN_CENTER:String = "center";
		
		/**
		 * A static constant describing the horizontal right-alignment. 
		 */	
		public static const ALIGN_RIGHT:String = "right";
		
		public function AlignType() {
		}
	}
}