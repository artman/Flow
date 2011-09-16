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

package com.flow.graphics.fills {
	
	import com.flow.events.InvalidationEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	public class BitmapFill extends EventDispatcher implements IFill {
		
		private var _source:Class;
		private var _bitmap:BitmapData;
		private var _xOffset:Number = 0;
		private var _yOffset:Number = 0;

		public function BitmapFill() {
		}
		
		public function get source():Class {
			return _source;
		}
		public function set source(value:Class):void {
			if(value != _source) {
				_source = value;
				var instance:* = new _source();
				bitmap = (instance is Bitmap) ? (instance as Bitmap).bitmapData : instance;
			}
		}
		
		public function get bitmap():BitmapData {
			return _bitmap;
		}
		public function set bitmap(value:BitmapData):void {
			_bitmap = value;
		}
		
		public function get xOffset():Number {
			return _xOffset;
		}
		public function set xOffset(value:Number):void {
			if(value != _xOffset) {
				_xOffset = value;
				invalidate();
			}
		}
		
		public function get yOffset():Number {
			return _yOffset;
		}
		public function set yOffset(value:Number):void {
			if(value != yOffset) {
				_yOffset = value;
				invalidate();
			}
		}
		
		public function beginDraw(graphics:Graphics, width:int, height:int):void {
			if(_bitmap) {
				var matrix:Matrix = new Matrix();
				matrix.translate(_xOffset, _yOffset);
				graphics.beginBitmapFill(_bitmap, matrix, true, false);
			}
		}
		
		public function endDraw(graphics:Graphics):void  {
			if(_bitmap) {
				graphics.endFill();
			}
		}
		
		public function invalidate():void {
			dispatchEvent(new InvalidationEvent(InvalidationEvent.INVALIDATE));
		}
	}
}