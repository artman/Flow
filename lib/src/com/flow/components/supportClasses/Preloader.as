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

package com.flow.components.supportClasses {
	 
	import com.flow.containers.Application;
	import com.flow.log.Log;
	
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	/**
	 * The base class for preloaders that are displayed as the application is loaded.
	 * 
	 * To create an application with a preloader, subclass Preloader and override the draw method, and assign
	 * the full class path of your main application to the mainClassName parameter. If you omit the mainClassName
	 * the preloader will user the SWF name as the name of the main class to instantiate.
	 * 
	 * Finally, add some metadata to your application class to tell Flex to use your preloader:
	 * <code>[Frame(factoryClass="com.myapp.MyPreloader")]</code>
	 */	
	public class Preloader extends MovieClip {
		
		public static var instance:Preloader;
		private var _mainClassName:String;
		private var _loadingProgress:int;
		private var _removeAfterLoadingDone:Boolean = true;
		private var firstDraw:Boolean = true;
		
		/**
		 * Constructor 
		 */		
		public function Preloader() {
			instance = this;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			addEventListener(Event.ENTER_FRAME, checkProgress);
			stage.addEventListener(Event.RESIZE, resize);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
		}
		
		private function resize(e:Event):void {
			if(stage) {
				draw(stage.stageWidth, stage.stageHeight);
			}
		}
		
		public function redraw(e:* = null):void {
			draw(stage.stageWidth, stage.stageHeight);
		}
		 
		private function progress(e:ProgressEvent):void {
			loadingProgress = Math.floor(100 * e.bytesLoaded / e.bytesTotal);
			draw(stage.stageWidth, stage.stageHeight);
		}
		 
		private function checkProgress(e:Event):void {
			if(firstDraw) {
				draw(stage.stageWidth, stage.stageHeight);
				firstDraw = false;
			}
			if (currentFrame == totalFrames) {
				removeEventListener(Event.ENTER_FRAME, checkProgress);
				preloadingDone();
				stop();
			}
		}
		 
		private function preloadingDone():void {
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			if (!mainClassName) {
				var url:String = loaderInfo.loaderURL.split("?")[0];
				var dot:int = url.lastIndexOf(".");
				var slash:int = url.lastIndexOf("/");
				mainClassName = url.substring(slash + 1, dot);
			}
			var mainClass:Class = Class(getDefinitionByName(mainClassName));
			var app:Application = new mainClass() as Application;
			stage.addChildAt(app, 0);
			if(removeAfterLoadingDone) {
				remove();
			} else {
				app.preloader = this;
			}
		}
		
		/**
		 * Override this method and draw your preloader view according to the width and height. This will be called
		 * whenever the stage size changes or the loading progress changes. 
		 * @param The width to draw.
		 * @param The height to draw.
		 */		
		public function draw(width:Number, height:Number):void {
			// Nothing
		}
		
		/** Removes the preloader from the display list */ 	
		public function remove():void {
			stage.removeEventListener(Event.RESIZE, resize);
			stage.removeChild(this);
		}

		/** 
		 * The name of the main application class. An instance of this class will be added to the display list once
		 * the application has fully loaded. 
		 */
		public function get mainClassName():String {
			return _mainClassName;
		}
		public function set mainClassName(value:String):void {
			_mainClassName = value;
		}

		/** The progress of the load (0-1). Use this property to draw a progress bar on every draw-call. */
		public function get loadingProgress():int {
			return _loadingProgress;
		}

		public function set loadingProgress(value:int):void {
			_loadingProgress = value;
		}

		/** 
		 * Whether to automatically remove the preloader when the application has loaded and initialized. If you set this to false
		 * you need to call remove when you're ready to remove the preloader. This is usefull if you still want to display the preloader
		 * once your main application class has loaded to load other data.
		 */
		public function get removeAfterLoadingDone():Boolean {
			return _removeAfterLoadingDone;
		}

		public function set removeAfterLoadingDone(value:Boolean):void {
			_removeAfterLoadingDone = value;
		}


	}
}