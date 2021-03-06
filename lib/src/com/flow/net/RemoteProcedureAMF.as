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
	
	/** @private */ 
	public class RemoteProcedureAMF {
		
		[Bindable] public var lastResult:* = null;
		[Bindable] public var lastError:* = null;
		
		[Inspectable(category="Data")]
		public var gateway:AMFGateway;
		
		public var procedure:String;
		private var _parameters:Array;
		public var autoSend:Boolean = false;
		private var lastResponder:AMFGatewayResponder;

		public function RemoteProcedureAMF() {
		}
		
		public function get parameters():Array {
			return _parameters;
		}

		public function set parameters(value:Array):void {
			if(_parameters != value) {
				_parameters = value;
				if(autoSend) {
					send();
				}
			}
		}

		public function send():void {
			var params:Array = [procedure].concat(parameters);
			if(lastResponder) {
				lastResponder.addHandlers(null, null);
			}
			lastResponder = gateway.rp.apply(this, params);
			lastResponder.addHandlers(result, error);
		}
		
		private function result(result:*):void {
			lastResult = result;
		}
		
		private function error(error:*):void {
			lastError = error;
		}
	}
}