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

package com.flow.net.loaders {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;

	/**
	 * Dispatched, when all loaders in the batch have completed sucessfully.
	 * @eventType flash.events.Event.COMPLETE
	 */  
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched, when one of the loaders in the batch fails.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */  
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Dispatched, whenever any of the loaders in the batch progresses.
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */  
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * Creates a batch of multiple loaders that can be tracked as a group.
	 */
	public class LoaderBatch extends EventDispatcher {
		
		private var completed:int = 0;
		
		/** All loaders in the batch */
		public var loaderBatch:Vector.<AbstractLoader>;
		
		/**
		 * Constructor. Creates a loader batch.
		 * @param AbstractLoaders to put into the batch.
		 */
		public function LoaderBatch(...rest) {
			loaderBatch = new Vector.<AbstractLoader>();
			if (rest.length > 0) {
				for(var i:int = 0; i<rest.length; i++) {
					addLoaders(rest[i]);
				}
			}
		}

		/**
		 * Adds a loader instance into the batch.
		 * @param The AbstractLoader instance to add to the batch.
		 */
		public function addLoader(loader:AbstractLoader):void {
			removeLoader(loader);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(Event.COMPLETE, complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioerror);
			loaderBatch.push(loader);
		}
		
		/**
		 * Adds a number of loader instances to the batch.
		 * @param The AbstractLoader instances to add to the batch.
		 */
		public function addLoaders(...rest):void {
			for (var i:int = 0; i < rest.length; i++ ) {
				addLoader(rest[i]);
			}
		}
		
		/**
		 * Removes a Loader instance from the batch.
		 * @param The AbstractLoader instance to remove from the batch.
		 */
		public function removeLoader(loader:AbstractLoader):void {
			var index:int = loaderBatch.indexOf(loader);
			if(index != -1) {
				removeEventListenersForLoader(loaderBatch[index]);
				loaderBatch.splice(index, 1);
			}
		}

		private function ioerror(e:IOErrorEvent):void {
			var evt:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
			evt.text = e.text;
			dispatchEvent(evt);
			removeLoader(e.currentTarget as AbstractLoader);
			if (completed == loaderBatch.length) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function complete(e:Event):void {
			completed++;
			removeEventListenersForLoader(e.currentTarget as AbstractLoader);
			if (completed == loaderBatch.length) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function progressHandler(e:ProgressEvent):void {
			var evt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			for (var i:int = 0; i < loaderBatch.length; i++ ) {
				// TODO: Calculate bytes loaded and total
			}
			evt.bytesLoaded = 0;
			evt.bytesTotal = 0;
			dispatchEvent(evt);
		}
		
		private function removeEventListenersForLoader(loader:AbstractLoader):void {
			loader.removeEventListener(Event.COMPLETE, complete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, ioerror);
			loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		/**
		 * Gets the cumlative progress of all loaders in the batch (0-1). 1 means that all tracked instances have 
		 * finished loading successfully.
		 */
		public function get progress():Number {
			var num:int = loaderBatch.length;
			var totalProgress:Number = 0;
			for (var i:int = 0; i < loaderBatch.length; i++ ) {
				totalProgress += loaderBatch[i].progress;
			}
			return totalProgress / loaderBatch.length;
		}
		
		/**
		 * Closes all loaders in the batch operations.
		 */		
		public function close():void {
			for (var i:int = loaderBatch.length - 1; i >= 0; i-- ) {
				removeEventListenersForLoader(loaderBatch[i]);
			}
			loaderBatch = new Vector.<AbstractLoader>();
		}
	}
}