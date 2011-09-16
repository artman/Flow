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

package com.flow.utils {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	/**
	 * A collection of static graphics-related methods. 
	 */	
	public class GraphicUtils {
		public function GraphicUtils() {
		}
		
		/**
		 * Turns any DisplayObject into BitmapData of the given size. Should the aspect ratio of the DisplayObject and the given
		 * width and height not match, the DisplayObject is cropped. 
		 * @param The display object to draw.
		 * @param The width of the resulting BitmapData instance.
		 * @param The height of the resulting BitmapData instance.
		 * @return A BitmapData instance.
		 */		
		public static function draw(dis:DisplayObject, w:int, h:int):BitmapData {
			var bmp:BitmapData = new BitmapData(w,h);
			var scaleX:Number = dis.scaleX;
			var scaleY:Number = dis.scaleY;
			dis.scaleX = dis.scaleY = 1;
			
			var aspect:Number = w / h;
			var disAspect:Number = dis.width / dis.height;
			var scale:Number = 0;
			var xOffset:Number = 0;
			var yOffset:Number = 0;
			
			if(disAspect > aspect) {
				scale = h / dis.height;
				xOffset = (dis.width*scale - w) / 2;
			} else {
				scale = w / dis.width;
				yOffset = (dis.height*scale - h) / 2;
			}
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			matrix.translate(-xOffset, -yOffset);
			bmp.draw(dis, matrix);
			
			dis.scaleX = scaleX;
			dis.scaleY = scaleY;
			return bmp;
		}
		
		/**
		 * Flips a BitmapData instance horizontally. 
		 * @param The source BitmapData instace to flip.
		 * @return A flipped BitmapData instance.
		 */		
		public static function flipHorizontally(source:BitmapData):BitmapData {
			var bmp:BitmapData = new BitmapData(source.width, source.height);
			var matrix:Matrix = new Matrix();
			matrix.scale(-1,1);
			matrix.translate(source.width, 0);
			bmp.draw(source, matrix);
			return bmp;
		}
	}
}