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
	
	import com.flow.events.AMFGatewayEvent;
	
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	
	[Event(name="result", type="com.flow.events.AMFGatewayEvent")]
	[Event(name="error", type="com.flow.events.AMFGatewayEvent")]
	
	/**
	 * AMFGateway provides a easy way to consume remote AMF services.
	 */	
	public class AMFGateway extends NetConnection {
		
		private var _url:String;
		
		/**
		 * Constructor. 
		 * @param The gateway URL to connect to.
		 */		
		public function AMFGateway(url:String = "") {
			super();
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF3;
			defaultObjectEncoding = ObjectEncoding.AMF3;
			objectEncoding = ObjectEncoding.AMF3;
			addEventListener(NetStatusEvent.NET_STATUS, status);
			this.url = url;
		}
		
		/**
		 * The url to which the AMFGateway instance is connected to. 
		 */		
		[Bindable]
		public function get url():String {
			return _url
		}
		public function set url(value:String):void {
			if(value != _url) {
				_url = value;
				if(_url.length) {
					connect(_url);
				}
			}
		}
		
		/**
		 * Calls a remote procedure on the gateway. 
		 * @param The procedure name to call
		 * @param Any parameters to send to the procedure.
		 * @return A GatewayResponder instance that you can use to wait for a response from the procedure call.
		 */		
		public function rp(remoteProcedure:String, ...rest):AMFGatewayResponder {
			var resp:AMFGatewayResponder = new AMFGatewayResponder();
			resp.addEventListener(AMFGatewayEvent.ERROR, error);
			var params:Array = [remoteProcedure, resp].concat(rest);
			call.apply(this, params);
			return resp;
		}

		private function error(e:AMFGatewayEvent):void{
			var evt:AMFGatewayEvent = new AMFGatewayEvent(AMFGatewayEvent.ERROR);
			evt.result = e.result;
			dispatchEvent(evt);
		}
		
		private function status(e:NetStatusEvent):void {
			// TODO: Handle this?
		}
	}
}