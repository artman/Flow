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
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.Responder;
	
	[Event(name="complete", type="com.flow.events.AMFGatewayEvent")]
	[Event(name="error", type="com.flow.events.AMFGatewayEvent")]
	
	/**
	 * A AMFGatwayResponder instance is returned by each remote procedure call. You can use the addHandlers-method to register success- and error-
	 * callbacks that are called when the remote procedure has executed. 
	 */	
	public class AMFGatewayResponder extends Responder implements IEventDispatcher {
		
		private var eventDispatcher:EventDispatcher;
		private var remoteProcedure:String;
		
		private var resultHandler:Function = null;
		private var errorHandler:Function = null;
		
		/**
		 * Constructor. There should be no need for you to create an instance of the AMFGatewayResponder yourself.
		 */		
		public function AMFGatewayResponder(){
			super(result, error);
			eventDispatcher = new EventDispatcher(this);
		}
		
		private function result(resp:Object):void{
			if(resultHandler != null) {
				resultHandler(resp);
			}
			var e:AMFGatewayEvent = new AMFGatewayEvent(AMFGatewayEvent.COMPLETE);
			e.result = resp;
			dispatchEvent(e);
		}
		
		private function error(err:Object):void{
			if(errorHandler != null) {
				errorHandler(err);
			}
			var e:AMFGatewayEvent = new AMFGatewayEvent(AMFGatewayEvent.ERROR);
			e.result = err;
			dispatchEvent(e);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
			eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean{
			return eventDispatcher.hasEventListener(type)
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return eventDispatcher.willTrigger(type);
		}
		
		/**
		 * Register callback functions that are called when the remote procedure call that returned the AMFGatewayResponder instance returns. 
		 * @param The function to invoke when the remote procedure has returned successfully. The callback will be called with one parameter containing the result
		 * of the remote procedure call.
		 * @param The function to invoke when the remote procedure returns with an error. The callback will be called with one parameter containing the error
		 * object returned by the procedure call.
		 */		
		public function addHandlers(resultHandler:Function, errorHandler:Function = null):void {
			this.resultHandler = resultHandler;
			this.errorHandler = errorHandler;
		}
	}
	
}