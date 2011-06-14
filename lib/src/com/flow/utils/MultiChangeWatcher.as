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
	
	import mx.binding.utils.ChangeWatcher;
	
	/**
	 * MultiChangeWatcher is a Binding util that lets you listen to multiple properties on one target. A change to
	 * any of the properties will call the handler function.
	 */	
	public class MultiChangeWatcher {
		private var properties:Array;
		private var handler:Function;
		private var watchers:Vector.<ChangeWatcher>;
		
		/**
		 * Constructor. Starts listening to property changes on a target object. 
		 * @param The target object to listen to
		 * @param The properties to listen to. Properties can be chained just like with BindingUtils.
		 * @param The handler that should be called when any of the target properties change.
		 * @example new MultiChangeWatcher(myObj, ["x", "content.value"], myHandler);
		 * 
		 */		
		public function MultiChangeWatcher(target:Object, properties:Array, handler:Function) {
			watchers = new Vector.<ChangeWatcher>();
			this.properties = properties;
			this.handler = handler;
			for(var i:int = 0; i<properties.length; i++) {
				var prop:String = properties[i];
				var mp:Array = prop.split(".");
				if(mp.length > 1) {
					watchers.push(ChangeWatcher.watch(target, mp, handleChange));
				} else {
					watchers.push(ChangeWatcher.watch(target, mp[0], handleChange));
				}
			}
		}
		
		/**
		 * Unwatches all watched properties. 
		 */		
		public function unwatch():void {
			for(var i:int = 0; i<watchers.length; i++) {
				watchers[i].unwatch();
			}
			watchers = null;
		}
		
		private function handleChange(e:Event):void {
			handler();
		}
	}
}