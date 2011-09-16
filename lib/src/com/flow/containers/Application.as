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
	
	import com.flow.motion.Tween;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import com.flow.components.Component;
	import com.flow.components.supportClasses.Preloader;
	import com.flow.managers.TooltipManager;
	
	public class Application extends Container {
		
		public static var application:Application;
		public var preloader:Preloader;
		public var tooltipRoot:Sprite;
		private var debugLog:TextField;
		
		public function Application(){
			super()
			application = this;
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
		
		public function get frameRate():int {
			return stage.frameRate;
		}
		public function set frameRate(value:int):void {
			stage.frameRate = value;
		}
		
		public function getParameter(key:String, defaultValue:* = null):* {
			if(stage.loaderInfo.parameters[key] != undefined) {
				var val:* = stage.loaderInfo.parameters[key];
				if(defaultValue is Boolean) {
					val = val == "true" ? true : false;
				}
				return val;
			}
			return defaultValue;
		}
		
		override public function validateChildren():void {
			super.validateChildren();
			rawAddChild(tooltipRoot);
		}
		
		public function debug(text:String):void {
			if(!debugLog) {
				debugLog = new TextField();
				debugLog.multiline = true;
				debugLog.wordWrap = true;
				debugLog.width = 500;
				debugLog.height = 400;
				stage.addChild(debugLog);
			}
			debugLog.appendText(text + "\n");
			debugLog.scrollV = debugLog.numLines;
		}
	}
}