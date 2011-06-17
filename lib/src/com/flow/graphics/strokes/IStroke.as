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

package com.flow.graphics.strokes {
	
	import com.flow.motion.IAnimateable;
	
	import flash.display.Graphics;
	import flash.events.IEventDispatcher;
	
	/**
	 * A IStroke instance is responsible for setting the lineStyle on the graphics context that is about to be drawn to.
	 */	
	public interface IStroke extends IEventDispatcher, IAnimateable {
		/**
		 * The stroke needs to set the lineStyle on the given graphics context. 
		 * @param The graphics context whos lineStyle to set.
		 * @param The width of the rendering that is about to happen.
		 * @param The height of the rendering that is about to happen.
		 */		
		function beginDraw(graphics:Graphics, width:int, height:int):void;
		function get thickness():Number;
	}
}