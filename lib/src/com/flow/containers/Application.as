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

package com.flow.containers {
	
	import com.flow.components.Component;
	import com.flow.components.supportClasses.Preloader;
	import com.flow.managers.TooltipManager;
	import com.flow.motion.Tween;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.text.TextField;
	
	/**
	 * The base container for any Flow application. This needs to be at the root of your Flow-based application.
	 */	
	public class Application extends Container {
		
		[Bindable] public static var application:Application;
		
		/** The preloader that has been assigned to this application  */		
		public var preloader:Preloader;
		/** @private */
		public var tooltipRoot:Sprite;
		private var debugLog:TextField;
		private var applicationStoredParams:SharedObject;
		
		/** Constructor */		
		public function Application(){
			super()
			application = this;
			applicationStoredParams = SharedObject.getLocal("ApplicationParams");
			if(stage) {
				initApplication();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, added);
			}
		}
		
		private function added(e:Event):void {
			initApplication();
			removeEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function initApplication():void {
			Tween.staticInit(this);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			percentWidth = 100;
			percentHeight = 100;
			tooltipRoot = new Sprite();
			addChild(tooltipRoot);
			Component.manager.initialize(stage);
			TooltipManager.instance.setRoot(tooltipRoot);
		}
		
		/** The frame-rate of the application. */		
		public function get frameRate():int {
			return stage.frameRate;
		}
		public function set frameRate(value:int):void {
			stage.frameRate = value;
		}
		
		/**
		 * Fetches a parameter that has been passed to your application via HTML. 
		 * @param The parameter name
		 * @param A default value that will be returned if the parameter hasn't been passed to your application via HTML.
		 * @return The value of the parameter.
		 */		
		public function getParameter(name:String, defaultValue:* = null):* {
			if(stage.loaderInfo.parameters[name] != undefined) {
				var val:* = stage.loaderInfo.parameters[name];
				if(defaultValue is Boolean) {
					val = val == "true" ? true : false;
				}
				return val;
			}
			return defaultValue;
		}
		
		/**
		 * Stores a value for later access across sessions on the same domain. 
		 * @param The name of the parameter
		 * @param The value of the parameter
		 * @return A string containing one of the values of SharedObjectFlushStatus or "error", if the user has disallowed saving.
		 */		
		public function storeParameter(name:String, value:*):String {
			applicationStoredParams.data[name] = value;
			try {
				var ret:String = applicationStoredParams.flush();
				return ret;
			} catch(e:Error) {}
			return "Error";			
		}
		
		/**
		 * Retreives a previously saved parameter. 
		 * @param The paramater name to retreive
		 * @param A default value to return if the parameter is not found.
		 * @return The value of the parameter or the defaultValue.
		 */		
		public function getStoredParameter(name:String, defaultValue:* = null):* {
			if(name in applicationStoredParams.data) {
				return applicationStoredParams.data[name];
			}
			return defaultValue;	
		}
		
		/**
		 * Deletes a previously stored parameter.
		 * @param The parameter name to store
		 */			
		public function deleteStoredParameter(name:String):void {
			try {
				delete applicationStoredParams.data[name];
				applicationStoredParams.flush();
			} catch(e:Error) {}
		}
			
		/**
		 * Checks whether a parameter has been previously saved. 
		 * @param The name of the parameter to find.
		 * @return True if the parameter was found, false otherwise.
		 */		
		public function hasStoredParameter(name:String):Boolean {
			if(name in applicationStoredParams.data) {
				return true;
			}
			return false;	
		}
		
		/** @private */
		override public function validateChildren():void {
			super.validateChildren();
			rawAddChild(tooltipRoot);
		}
	}
}