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
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public function callLater(closure:Function, frameCount:int = 1, ...rest):void {
		var beacon:Sprite = new Sprite();
		Hooks.callLaterHooks[beacon] = closure; 
		var timedFunction:Function=function():void{
			if(--frameCount <= 0){
				beacon.removeEventListener(Event.ENTER_FRAME,timedFunction);
				closure.apply(this,rest);
				delete Hooks.callLaterHooks[beacon];
			}
		};
		beacon.addEventListener(Event.ENTER_FRAME,timedFunction);
	}	
}

internal class Hooks {
	import flash.utils.Dictionary;
	public static var callLaterHooks:Dictionary = new Dictionary(false); 
}


