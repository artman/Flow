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

package mx.states {
	
	import flash.events.EventDispatcher;
	
	[DefaultProperty("overrides")]	
	public class State extends EventDispatcher {
		private var initialized:Boolean = false;
		public var name:String;		
		private var _overrides:Array;
		public var transitionSpeed:Number = 0;
		
		public function State(properties:Object=null) {
			overrides = [];
			super();
			if(properties is String) {
				name = properties as String;
			} else {
				for (var p:String in properties) {
					this[p] = properties[p];
				}
			}
		}
		
		public function get overrides():Array {
			return _overrides;
		}
		public function set overrides(value:Array):void {
			_overrides = value;
		}
		
		public function initialize():void {
			if (!initialized) {
				initialized = true;
				for (var i:int = 0; i < overrides.length; i++) {
					IOverride(overrides[i]).initialize();
				}
			} 
		} 
		
		public function apply(target:Object):void {
			for (var i:int = 0; i < overrides.length; i++) {
				IOverride(overrides[i]).apply(target);
			}
		}
		
		public function remove(target:Object):void {
			for (var i:int = 0; i < overrides.length; i++) {
				IOverride(overrides[i]).remove(target);
			}
		}
	}
}
