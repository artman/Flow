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

package com.flow.commands {
	
	import com.flow.events.CommandEvent;
	import com.flow.utils.callLater;
	
	import flash.events.EventDispatcher;
	
	/**
	 * Dispatched when the command completes. This is only dispatched for events that don't finish immediately and call the complete-method, such
	 * as RPC commands. 
	 */	
	[Event(name="complete", type="com.flow.events.CommandEvent")]
	
	/**
	 * Dispatched when a command finishes with an error, such as a RPC failure. 
	 */	
	[Event(name="error", type="com.flow.events.CommandEvent")]
	
	/**
	 * The base-class for all commands in an Flow application. Flow defines a simple MVC model to separate visual representation from data and 
	 * commands. In Flow, there is no command controller that acts as the glue between user triggered events and commands. Instead, whenever
	 * you need to call a command, you intantiate the command class directly. This requires far less boiler-plate code than other MVC
	 * implementations and has only a few draw-backs (e.g. chaining commands is a bit more tedious).
	 * 
	 * Commands that don't terminate instantly in the constuctor (e.g RPC reliant commands) should call the complete-method once they've
	 * completed their work in order for completion-notifications to be send out correctly.
	 * 
	 * If any component needs to be notified whenever a specific command is run or has finished, you use the CommandDispatch singleton.
	 * 
	 * @see CommandDispatch
	 */	
	public class Command extends EventDispatcher {
		
		private var completeHandler:Function = null;
		private var errorHandler:Function = null;
		public var data:*;
		
		/**
		 * Constructor. Sub-classes should always call super on their constructors to make sure that command events are dispatched. 
		 */		
		public function Command() {
			CommandDispatch.instance.executeCommand(this);
			callLater(executed, 1);
		}
		
		private function executed():void {
			CommandDispatch.instance.executedCommand(this);
		}
		
		/**
		 * Whenever a command contains RPC operations, or operations that don't finish immediately, sub-classes need to call the 
		 * sueper-classes complete-method to notify that the command has completed and optionally pass in any data retreived or
		 * computed by the command.  
		 * @param The data was retreived or computed.
		 */		
		protected function complete(data:* = null):void { 
			this.data = data;
			if(completeHandler != null) {
				completeHandler(data);
			}
			var evt:CommandEvent = new CommandEvent(CommandEvent.COMPLETE);
			evt.data = data;
			dispatchEvent(evt);
			CommandDispatch.instance.completeCommand(this);
		}
		
		/**
		 * Whenever a command finishes with an error (such as a network error for RPC's), sub-classes call the error-method to
		 * notify the user of a unsucessfull completion of the command. 
		 * @param Any data associated with the error.
		 */		
		protected function error(data:* = null):void { 
			this.data = data;
			if(errorHandler != null) {
				errorHandler(data);
			}
			var evt:CommandEvent = new CommandEvent(CommandEvent.ERROR);
			evt.data = data;
			dispatchEvent(evt);
		}
		
		/**
		 * Adds functions that handle the successfull or unsucessfull completion of the command. 
		 * @param A function that is called when the command completes successfully. Any data passed to the commands complete-method
		 * is passed to this callback.
		 * @param A function that is called when the command completes unsucessfully. Any data passed to the commands error-method
		 * is passes to this callback.
		 */		
		public function addHandlers(complete:Function, error:Function = null):void {
			completeHandler = complete;
			errorHandler = error;
		}
	}
}