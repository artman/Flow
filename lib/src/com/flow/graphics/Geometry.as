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

package com.flow.graphics {
	
	import com.flow.components.Component;
	
	[DefaultProperty("stroke")]
	public class Geometry extends Component {
		
		public function Geometry() {
			super();
		}

		override protected function checkVisibility():Boolean {
			return true;
		}
		
		override public function draw(w:int, h:int):void {	
			graphics.clear();
			graphics.lineStyle(undefined);
			if (_stroke) {
				_stroke.beginDraw(graphics, w, h);
			}
			if (_fill) {
				_fill.beginDraw(graphics, w, h);
			}
		}
		
		public function endDraw():void  {
			if (_stroke) {
				_stroke.endDraw(graphics);
			}
			if (_fill) {
				_fill.endDraw(graphics);
			}
		}
	}
}