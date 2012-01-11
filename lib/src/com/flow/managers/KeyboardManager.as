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

package com.flow.managers {
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	/**
	 * Dispatched when a key has been released. 
	 */	
	[Event(name="keyUp", type="flash.events.KeyboardEvent")]
	
	/**
	 * Dispatched when a key is pressed. 
	 */	
	[Event(name="keyDown", type="flash.events.KeyboardEvent")]
	
	/**
	 * A utility singleton to retreive key states or listen to keyboard events. 
	 */	
	public class KeyboardManager extends EventDispatcher {
		
		private var keysDown:Dictionary;
		
		/**
		 * The singleton instance. 
		 */		
		public static var instance:KeyboardManager = new KeyboardManager();
		
		/**
		 * Constructor.
		 */		
		public function KeyboardManager(){
			keysDown = new Dictionary();
		}
		
		/**
		 * Initializes the KeyboarManager. This needs to be called once from your application before using any of the manager's methods. 
		 * @param A reference to the stage
		 */		
		public function initialize(stage:Stage):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed, false, 1000);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyReleased, false, 1000);
		}
		
		/**
		 * Check if a key is currently beeing pressed. 
		 * @param The key code to check for
		 * @return True, if the key is beeing pressed, false otherwise.
		 */		
		public function isKeyDown(code:int):Boolean {
			if(keysDown[code]){
				return true;
			} else {
				return false;
			}
		}
		
		private function keyPressed(event:KeyboardEvent):void {
			if(!isKeyDown(event.keyCode)) {
				keysDown[event.keyCode] = true;
			}			
			dispatchEvent(event.clone());
		}
		
		private function keyReleased(event:KeyboardEvent):void {
			if(isKeyDown(event.keyCode)) {
				delete keysDown[event.keyCode];
			}
			dispatchEvent(event.clone());
		}
	}   
}