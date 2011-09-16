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
	
	import com.flow.motion.IAnimateable;
	
	import flash.display.Graphics;
	import flash.events.IEventDispatcher;
	
	/**
	 * A IFill instance is responsible to call beginFill and endFill on the graphics context before and after drawing occurs. 
	 */	
	[Event(name="invalidate", type="com.flow.events.InvalidateEvent")]
	public interface IFill extends IEventDispatcher, IAnimateable {
		/**
		 * Called when a draw is about to commence on the given graphics context. The implementation needs to begin a fill on the
		 * given graphics context.
		 * @param The graphics context to begin the fill on.
		 * @param The width at which a draw is about to commence.
		 * @param The height at which a draw is about to commence.
		 * 
		 */		
		function beginDraw(graphics:Graphics, width:int, height:int):void ;
		/**
		 * Called when a draw has finished. The implementation needs to end the fill on the given graphics context. 
		 * @param The graphics context to end the fill on.
		 */		
		function endDraw(graphics:Graphics):void;
	}
}