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
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	
	/**
	 * Loads text data from a remote URL.
	 */
	public class TextLoader extends LoaderBase {
		
		private var text:String;
		private var loader:URLLoader;
		
		/**
		 * Constructor. Starts the loading operation
		 * @param The URL from which to load the data. This can be of type String or URLRequest. If String, a URLRequest is automatically
		 * created using GET.
		 */
		public function TextLoader(url:*) {
			super(url);
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, fail);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fail);
			loader.load(this.url);
		}
		
		/** @private */
		override protected function complete(e:Event):void {
			text = e.target.data;
			super.complete(e);
		}
		
		/** @private */
		override protected function removeLoaderEventListeners():void {
			loader.removeEventListener(Event.COMPLETE, complete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, fail);
			loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
		}
		
		/** @inheritDoc */
		override public function close():void {
			loader.close();
			super.close()
		}
		
		/** The resulting text of the load operation. */
		override public function get result():* {
			return text;
		}
	}
}