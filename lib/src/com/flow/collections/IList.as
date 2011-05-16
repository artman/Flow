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

package com.flow.collections  {
	
	import flash.events.IEventDispatcher;
	
	[Event(name="collectionChange", type="fi.artman.eventns.CollectionEvent")]
	public interface IList extends IEventDispatcher {
		function get length():int;
		function addItem(item:Object):void;
		function addItemAt(item:Object, index:int):void;
		function getItemAt(index:int, prefetch:int = 0):Object;
		function getItemIndex(item:Object):int;
		function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null):void;
		function removeAll():void;
		function removeItemAt(index:int):Object;
		function setItemAt(item:Object, index:int):Object;
		function toArray():Array;
	}
}
