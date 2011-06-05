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

package com.flow.net {
	import com.flow.net.loaders.DisplayObjectLoader;
	import com.flow.net.loaders.JSONLoader;
	import com.flow.net.loaders.LoaderBase;
	import com.flow.net.loaders.TextLoader;
	import com.flow.net.loaders.XMLLoader;
	
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class RemoteProcedureHTTP {
		
		[Bindable] public var lastResult:* = null;
		[Bindable] public var lastError:* = null;
		
		public var url:String;
		public var type:String = "text";
		public var method:String = "GET";
		private var _parameters:Object;
		public var autoSend:Boolean = false;
		
		public function RemoteProcedureHTTP() {
		}
		
		public function get parameters():Object {
			return _parameters;
		}
		
		public function set parameters(value:Object):void {
			if(_parameters != value) {
				_parameters = value;
				if(autoSend) {
					send();
				}
			}
		}
		
		public function send():void {
			var req:URLRequest = new URLRequest(url);
			req.method = method;
			if(_parameters) {
				var variables:URLVariables = new URLVariables();
				for each(var prop:String in _parameters) {
					variables[prop] = _parameters[prop];
				}
				req.data = variables
			}
			
			var loader:LoaderBase;
			switch(type) {
				case RemoteProcedureTypes.TEXT: loader = new TextLoader(req); break;
				case RemoteProcedureTypes.JSON: loader = new JSONLoader(req); break;
				case RemoteProcedureTypes.XML: loader = new XMLLoader(req); break;
				case RemoteProcedureTypes.DISPLAY_OBJECT: loader = new DisplayObjectLoader(req); break;
			}
			loader.addHandlers(result, error);
		}
		
		private function result(result:*):void {
			lastResult = result;
		}
		
		private function error(error:*):void {
			lastError = error;
		}
	}
}