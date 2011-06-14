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

	/** @private */
	public class CommandDispatch extends EventDispatcher {
		
		public static var instance:CommandDispatch = new CommandDispatch();
		
		public function CommandDispatch() {
		}
		
		public function executeCommand(command:Command):void {
			var evt:CommandEvent = new CommandEvent(CommandEvent.EXECUTE + "_" + getQualifiedClassName(command));
			evt.command = command;
			dispatchEvent(evt);
		}
		
		public function executedCommand(command:Command):void {
			var evt:CommandEvent = new CommandEvent(CommandEvent.EXECUTED + "_" + getQualifiedClassName(command));
			evt.data = command.data;
			evt.command = command;
			dispatchEvent(evt);
		}
		
		public function completeCommand(command:Command):void {
			var evt:CommandEvent = new CommandEvent(CommandEvent.EXECUTE_COMPLETE + "_" + getQualifiedClassName(command));
			evt.data = command.data;
			evt.command = command;
			dispatchEvent(evt);
		}
		
		public function addExecuteListener(type:Class, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			addEventListener(CommandEvent.EXECUTE + "_" + getQualifiedClassName(type), listener, useCapture, priority, useWeakReference);
		}
		
		public function removeExecuteListener(type:Class, listener:Function, useCapture:Boolean=false):void {
			removeEventListener(CommandEvent.EXECUTE + "_" + getQualifiedClassName(type), listener, useCapture);
		}
		
		public function addExecutedListener(type:Class, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			addEventListener(CommandEvent.EXECUTED + "_" + getQualifiedClassName(type), listener, useCapture, priority, useWeakReference);
		}
		
		public function removeExecutedListener(type:Class, listener:Function, useCapture:Boolean=false):void {
			removeEventListener(CommandEvent.EXECUTED + "_" + getQualifiedClassName(type), listener, useCapture);
		}
		
		public function addCompleteListener(type:Class, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			addEventListener(CommandEvent.EXECUTE_COMPLETE + "_" + getQualifiedClassName(type), listener, useCapture, priority, useWeakReference);
		}
		
		public function removeCompleteListener(type:Class, listener:Function, useCapture:Boolean=false):void {
			removeEventListener(CommandEvent.EXECUTE_COMPLETE + "_" + getQualifiedClassName(type), listener, useCapture);
		}
	}
}