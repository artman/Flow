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
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * Dispatched, when data has loaded sucessfully.
	 * @eventType flash.events.Event.COMPLETE
	 */  
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched, when the load fails for some reason.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */  
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Dispatched, whenever the load progresses.
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */  
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * Dispatched, whenever a HTTPStatus event occurs
	 * @eventType flash.events.HTTPStatusEvent
	 */  
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 * Base class for loading data. This class is used as a super-class to all the other laoding classes
	 */
	public class AbstractLoader extends EventDispatcher {

		public var url:URLRequest;
		private var completeHandler:Function;
		private var errorHandler:Function;
		private var statusHandler:Function;
		private var _progress:Number = 0;
		public var loaded:Boolean = false;
		public var userData:*;
		
		/**
		 * Constrcutor.
		 * @param The URL from which to load data. This can be of type String or URLRequest. If a String is given, a URLRequest is automatically created using GET.
		 */
		public function AbstractLoader(url:*) {
			if (typeof(url) == "string")
				url = new URLRequest(url);
			this.url = url;
		}
		
		/**
		 * Assign functions to handle completion, errors and progress events.
		 * 
		 * @param The completeHandler is invoked when the load has completed sucessfully. A single parameter is passed with this call
		 * containing the data of the load operation. The type of the data depends on the sub-class.
		 * @param The errorHandler is invoked when a error occurs. A single parameter is passed into the handler containing the IOErrorEvent
		 * instance.
		 * @param The statusHandler is invoked when the laoding progresses. A single parameter is passed into the handler containing the ProgressEvent
		 * instance.
		 */
		public function addHandlers(completeHandler:Function, errorHandler:Function = null, statusHandler:Function=null):void {
			this.completeHandler = completeHandler;
			this.errorHandler = errorHandler;
			this.statusHandler = statusHandler;
		}
		
		/** @private */
		protected function complete(e:Event):void {
			loaded = true;
			removeLoaderEventListeners();
			if (completeHandler != null) {
				completeHandler(result)
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/** @private */
		protected function fail(e:IOErrorEvent):void {
			loaded = true;
			if (errorHandler != null) { 
				errorHandler(e);
			}
			if (hasEventListener(IOErrorEvent.IO_ERROR)) {
				var ioEvt:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
				ioEvt.text = e.text;
				dispatchEvent(ioEvt);
			}
			removeLoaderEventListeners();
		}
		
		/** @private */
		protected function securityFail(e:SecurityErrorEvent):void {
			loaded = true;
			if (errorHandler != null) { 
				errorHandler(e);
			}
			if (hasEventListener(SecurityErrorEvent.SECURITY_ERROR)) {
				var sEvt:SecurityErrorEvent = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
				sEvt.text = e.text;
				dispatchEvent(sEvt);
			}
			removeLoaderEventListeners();
		}
		
		/** @private */
		protected function httpStatus(event:HTTPStatusEvent) : void {
			if (statusHandler != null) {
				statusHandler(event);
			}
			var statusEvt : HTTPStatusEvent = new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS,false,false,event.status);
			dispatchEvent(statusEvt);
		}
		
		/**
		 * Stops the loading operation. No events are dispatched.
		 */		
		public function close():void {
			removeLoaderEventListeners();
		}
		
		/** @private */
		protected function progressHandler(e:ProgressEvent):void {
			if(!e.bytesTotal) {
				_progress = 0;
			} else {
				_progress = (1.0 * e.bytesLoaded) / e.bytesTotal;
			}
			var progressEvt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			progressEvt.bytesLoaded = e.bytesLoaded;
			progressEvt.bytesTotal = e.bytesTotal;
			dispatchEvent(progressEvt);
		}
		
		/** @private */
		protected function removeLoaderEventListeners():void {
			throw new Error("Subclass must override");
		}
		
		/** The progress of the load operation (0-1)  */
		public function get progress():Number {
			return _progress;
		}
		
		/** The data resulting from a successfull load operation. The type depends on the sub-class. */
		public function get result():* {
			throw new Error("Subclass must override");
		}		
	}
}