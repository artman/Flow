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
	
	import flash.display.Graphics;
	import flash.events.EventDispatcher;
	
	[Event(name="invalidate", type="com.flow.events.InvalidationEvent")]
	public class SolidFill extends EventDispatcher implements IFill {
		
		private var _alpha:Number = 1;
		private var _color:uint = 0x000000;
		
		public function SolidFill() {
		}
		
		[Animateable]
		public function get alpha():Number {
			return _alpha;
		}
		public function set alpha(value:Number):void {
			if(value != _alpha) {
				_alpha = value;
				invalidate();
			}
		}
		
		[Animateable(type="color")]
		public function get color():Number {
			return _color;
		}
		public function set color(value:Number):void {
			if(value != _color) {
				_color = value;
				invalidate();
			}
		}
		
		public function beginDraw(graphics:Graphics, width:int, height:int):void {
			graphics.beginFill(_color, _alpha);
		}
		
		public function endDraw(graphics:Graphics):void  {
			graphics.endFill();
		}
		
		private function invalidate():void {
			dispatchEvent(new InvalidationEvent(InvalidationEvent.INVALIDATE));
		}
	}
}