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

package com.flow.collections {
	
	import com.flow.events.CollectionEvent;
	import com.flow.events.CollectionEventKind;
	
	import flash.events.EventDispatcher;
	
	[DefaultProperty("source")]
	[Event(name="collectionChange", type="com.flow.events.CollectionEvent")]
	public class ArrayCollection extends EventDispatcher implements IList {
		
		private var _source:Array;
		
		public function ArrayCollection(source:Array = null) {
			super();
			if (!source) {
				_source = [];
			} else {
				_source = source;
			}
		}
		
		/**
		 * The source of the collection 
		 */		
		public function get source():Array {
			return _source; 
		}
		public function set source(value:Array):void {
			if(value != _source) {
				_source = value;
				var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET, -1, -1);
				dispatchEvent(event);
			}
		}
		
		/** @inheritDoc */
		public function get length():int {
			return _source.length;
		}
		
		/** @inheritDoc */
		public function addItem(item:Object):void {
			var index:uint = _source.push(item) - 1;
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, [item]);
			dispatchEvent(event);
		}
		
		/** @inheritDoc */
		public function addItemAt(item:Object, index:int):void {
			_source.splice(index, 0, item);
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.ADD, index, -1, [item]);
			dispatchEvent(event);
		}
		
		/** @inheritDoc */
		public function getItemAt(index:int, prefetch:int=0):Object {
			return _source[index];
		}
		
		/** @inheritDoc */
		public function getItemIndex(item:Object):int {
			return _source.indexOf(item);
		}
		
		/** @inheritDoc */
		public function itemUpdated(item:Object, property:Object=null, oldValue:Object=null, newValue:Object = null):void {
			var index:int = _source.indexOf(item);
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.UPDATE, index, index, [item]);
		}
		
		/** @inheritDoc */
		public function removeAll():void {
			_source = [];
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET, -1, -1, null);
			dispatchEvent(event);
		}
		
		/** @inheritDoc */
		public function removeItemAt(index:int):Object {
			var item:Object = _source.splice(index, 1);
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REMOVE, -1, index, item as Array);
			dispatchEvent(event);
			return item;
		}
		
		/** @inheritDoc */
		public function setItemAt(item:Object, index:int):Object {
			var oldItem:Object = _source.splice(index, 1, item);
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.REPLACE, index, index, [item]);
			dispatchEvent(event);
			return oldItem;
		}
		
		/** @inheritDoc */
		public function toArray():Array {
			var arr:Array = [];
			var i:int = 0;
			var len:uint = _source.length;
			for(; i < len; ++i) {
				arr.push(_source[i]);
			}
			return arr;
		}
	}
}