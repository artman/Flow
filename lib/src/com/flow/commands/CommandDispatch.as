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
	
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	 * A singleton class that enabels you to be notified whenever commands are called or completed.
 	 */
	public class CommandDispatch extends EventDispatcher {
		
		/**
		 * The singleton instance of the CommandDispatch. 
		 */		
		public static var instance:CommandDispatch = new CommandDispatch();
		
		/**
		 * Constructor. As this is a singleton, you never instantiate CommandDispatch yourself. 
		 */		
		public function CommandDispatch() {
		}
		
		/** @private */		
		public function executeCommand(command:Command):void {
			var evt:CommandEvent = new CommandEvent(CommandEvent.EXECUTE + "_" + getQualifiedClassName(command));
			evt.command = command;
			dispatchEvent(evt);
		}
		
		/** @private */
		public function executedCommand(command:Command):void {
			var evt:CommandEvent = new CommandEvent(CommandEvent.EXECUTED + "_" + getQualifiedClassName(command));
			evt.data = command.data;
			evt.command = command;
			dispatchEvent(evt);
		}
		
		/** @private */
		public function completeCommand(command:Command):void {
			var evt:CommandEvent = new CommandEvent(CommandEvent.EXECUTE_COMPLETE + "_" + getQualifiedClassName(command));
			evt.data = command.data;
			evt.command = command;
			dispatchEvent(evt);
		}
		
		/**
		 * Adds a listener that is called whenever a command of a specific type is instantiated. 
		 * @param The class of the command of whose execution you want to be notified.
		 * @param The function to call whenever the command is executed.
		 * @param Whether to use capture or not.
		 * @param The priority of the event handler.
		 * @param Whether to use weak referencing.
		 */		
		public function addExecuteListener(type:Class, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			addEventListener(CommandEvent.EXECUTE + "_" + getQualifiedClassName(type), listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Removes a previously added listener. 
		 * @param The class of the command you no longer want to receive events from.
		 * @param The listener function to remove.
		 * @param Whether to use capture or not.
		 */	
		public function removeExecuteListener(type:Class, listener:Function, useCapture:Boolean=false):void {
			removeEventListener(CommandEvent.EXECUTE + "_" + getQualifiedClassName(type), listener, useCapture);
		}
		
		/**
		 * Adds a listener that is called whenever a command of a specific type has been executed. This is called one frame
		 * after the command has been instantiated. 
		 * @param The class of the command of whose execution you want to be notified.
		 * @param The function to call whenever the command has been executed.
		 * @param Whether to use capture or not.
		 * @param The priority of the event handler.
		 * @param Whether to use weak referencing.
		 */	
		public function addExecutedListener(type:Class, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			addEventListener(CommandEvent.EXECUTED + "_" + getQualifiedClassName(type), listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Removes a previously added listener. 
		 * @param The class of the command you no longer want to receive events from.
		 * @param The listener function to remove.
		 * @param Whether to use capture or not.
		 */	
		public function removeExecutedListener(type:Class, listener:Function, useCapture:Boolean=false):void {
			removeEventListener(CommandEvent.EXECUTED + "_" + getQualifiedClassName(type), listener, useCapture);
		}
		
		/**
		 * Adds a listener that is called whenever a command of a specific type has completed successfully. Only commands that don't complete instantly
		 * (e.g. RPC's or timed commands) dispatch a complete-event. 
		 * @param The class of the command of whose completion you want to be notified.
		 * @param The function to call whenever the command has completed.
		 * @param Whether to use capture or not.
		 * @param The priority of the event handler.
		 * @param Whether to use weak referencing.
		 */	
		public function addCompleteListener(type:Class, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			addEventListener(CommandEvent.EXECUTE_COMPLETE + "_" + getQualifiedClassName(type), listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * Removes a previously added listener. 
		 * @param The class of the command you no longer want to receive events from.
		 * @param The listener function to remove.
		 * @param Whether to use capture or not.
		 */	
		public function removeCompleteListener(type:Class, listener:Function, useCapture:Boolean=false):void {
			removeEventListener(CommandEvent.EXECUTE_COMPLETE + "_" + getQualifiedClassName(type), listener, useCapture);
		}
	}
}