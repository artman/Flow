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
	
	/**
	 * Dipatched when the list is changed. 
	 */	
	[Event(name="collectionChange", type="com.flow.events.CollectionEvent")]
	
	/**
	 * A list of elements that can be manipulated with the given methods.
	 */	
	public interface IList extends IEventDispatcher {
		
		/**
		 * The number of elements in the list.
		 */		
		function get length():int;
		
		/**
		 * Adds an item to the list. 
		 * @param The item to add.
		 */		
		function addItem(item:Object):void;
		
		/**
		 * Adds an item to the list at a specific index. 
		 * @param The item to add
		 * @param The index to add the item at.
		 */		
		function addItemAt(item:Object, index:int):void;
		
		/**
		 * Retreives an item at a specific index.
		 * @param The index of the item to retreive.
		 * @return The item at the specified index.
		 */		
		function getItemAt(index:int, prefetch:int = 0):Object;
		
		/**
		 * Retreived the index of an item. 
		 * @param The item to retreive the index of.
		 * @return The index of the item.
		 */		
		function getItemIndex(item:Object):int;
		
		/** @private */		
		function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null):void;
		
		/**
		 * Removes all items from the list. 
		 */		
		function removeAll():void;
		/**
		 * Removes an item at a specific index. 
		 * @param The index of the item to remove.
		 * @return The removed item. 
		 */		
		
		function removeItemAt(index:int):Object;
		/**
		 * Overrides an item with a new item at a specific index.
		 * @param The item to add to the list
		 * @param The index at which to replace an existing item.
		 * @return The replaced item. 
		 */		
		
		function setItemAt(item:Object, index:int):Object;
		/**
		 * Returns the contents of the list as an Array. 
		 * @return An array of items in the list.
		 */		
		function toArray():Array;
	}
}
