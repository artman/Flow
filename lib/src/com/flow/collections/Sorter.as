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
	import com.flow.events.SorterEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	/**
	 * Dispatched when the sorter has detected a change in the ordering of it's items due to a change on the property that is beeing used for sorting. 
	 */	
	[Event(name="sortingChanged", type="com.flow.events.SorterEvent")]
	
	/**
	 * Sorter is used for sorting data in List containers. The duplicates data that is beeing assigned to it's dataProvider-property
	 * and outputs it to the sortedData-property. When added to a List container, the dataProvider property is automically populated
	 * with the dataProvider of the List, and the List display the sorted data.
	 */	
	public class Sorter extends EventDispatcher {
		
		private var _property:String = null;
		private var _ascending:Boolean = true;
		private var _descending:Boolean = false;
		private var _dataProvider:IList;
		private var _sortedData:IList;
		private var invalidated:Boolean = true;
		private var watchers:Vector.<ChangeWatcher>;
		
		/**
		 * Constructor 
		 */		
		public function Sorter() {
			watchers = new Vector.<ChangeWatcher>();
		}
		
		/**
		 * The name of the property according to which to sort the data.
		 */		
		public function get property():String {
			return _property;
		}
		public function set property(value:String):void {
			_property = value;
			updateDataBindings();
			invalidate();
		}
		
		/**
		 * The data to sort.  
		 */		
		public function get dataProvider():IList {
			return _dataProvider;
		}

		public function set dataProvider(value:IList):void {
			if(_dataProvider) {
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, updateDataBindings);
			}
			_dataProvider = value;
			updateDataBindings();
			if(_dataProvider) {
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, updateDataBindings);
			}
		}
		
		/**
		 * The sorted data. This is a copy of the data assigned to the dataProvider. 
		 */		
		public function get sortedData():IList {
			if(_sortedData && !invalidated) {
				return _sortedData;
			}
			if(_dataProvider) {
				invalidated = false;
				_sortedData = new ArrayCollection(getSortedArray());
				return _sortedData;
			}
			return null;
		}
		
		private function getSortedArray():Array {
			var data:Array = _dataProvider.toArray();
			var props:Array = [];
			if(_descending) {
				props.push(Array.DESCENDING);
			}
			data.sortOn(_property, props);
			return data;
		}
		
		private function updateDataBindings(e:Event = null):void {
			while(watchers.length) {
				watchers.shift().unwatch();
			}
			if(_dataProvider && property) {
				var cnt:int = _dataProvider.length;
				for(var i:int = 0; i<cnt; i++) {
					var item:Object = _dataProvider.getItemAt(i);
					if(ChangeWatcher.canWatch(item, property)) {
						watchers.push(ChangeWatcher.watch(item, property, watchedPropertyChanged));
					}
				}
				invalidate();
			}
		}
		
		private function watchedPropertyChanged(e:Event = null):void {
			if(_sortedData) {
				var oldArray:Array = _sortedData.toArray();
				var newArray:Array = getSortedArray();
				if(oldArray.length == newArray.length) {
					var cnt:int = oldArray.length;
					for(var i:int = 0; i<cnt; i++) {
						if(oldArray[i] != newArray[i]) {
							invalidate();
							return;
						}
					}
					return ;
				}
			}
			invalidate();
		}
		
		/**
		 * If set to true, the data is ordered ascending. 
		 */		
		public function get ascending():Boolean {
			return _ascending;
		}
		public function set ascending(value:Boolean):void {
			_ascending = value;
			_descending = !_ascending;
			invalidate();
		}

		/**
		 * If set to true, the data is ordered descending. 
		 */		
		public function get descending():Boolean {
			return _descending;
		}
		public function set descending(value:Boolean):void {
			_descending = value;
			_ascending = !_descending;
			invalidate();
		}
		
		public function invalidate(e:Event = null):void {
			var evt:SorterEvent = new SorterEvent(SorterEvent.SORTING_CHANGED);
			dispatchEvent(evt);
			invalidated = true;
		}
	}
}