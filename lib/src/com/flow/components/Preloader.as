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

package com.flow.components {
	 
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;

	public class Preloader extends MovieClip {
		 
		public var mainClassName:String;
		public var loadingProgress:int;
		public var removeAfterLoadingDone:Boolean = true;
		private var firstDraw:Boolean = true;
		
		public function Preloader() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			addEventListener(Event.ENTER_FRAME, checkProgress);
			stage.addEventListener(Event.RESIZE, resize);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
		}
		
		private function resize(e:Event):void {
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
				var url:String = loaderInfo.loaderURL;
				var dot:int = url.lastIndexOf(".");
				var slash:int = url.lastIndexOf("/");
				mainClassName = url.substring(slash + 1, dot);
			}
			var mainClass:Class = Class(getDefinitionByName(mainClassName));
			var app:Application = new mainClass() as Application;
			stage.addChild(app);
			if(removeAfterLoadingDone) {
				remove();
			} else {
				app.preloader = this;
			}
		}
		
		public function draw(width:int, height:int):void {
			// Nothing
		}
		
		public function remove():void {
			stage.removeEventListener(Event.RESIZE, resize);
			stage.removeChild(this);
		}
	}
}