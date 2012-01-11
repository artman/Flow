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

package com.flow.net.loaders {
	
	import com.flow.effects.Effect;
	import com.flow.motion.Tween;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.LoaderContext;
	
	/**
	 * Simple fire and forget loading of DisplayObjects (png, jpeg, gif, swf).
	 */
	public class DisplayObjectLoader extends AbstractLoader {
		
		private static var activeReplaceLoaders:Array = [];
		
		private var target:DisplayObjectContainer;
		private var replaceAllChildren:Boolean;
		/** @private */
		public var loader:Loader;
		private var content:DisplayObject;
		private var revealSpeed:Number = -1;
		
		/** Defines a fade-in-speed for the loaded content in seconds. If this >0, the content will be faded in once it has loaded */		
		public var fadeInSpeed:Number = 0;
		/** Defines a fade-in effect for the loaded content. If set, the content will be animated in with this effect once it has laoded */ 
		public var fadeInEffect:Effect;
		
		/**
		 * Constructor. Starts loading a display object.
		 * 
		 * @param The URL from which to load the DisplayObject. This can be of type String or URLRequest. If String, a URLRequest is automatically
		 * created using GET.
		 * @param If specified, automatically adds the loaded DisplayObject as the last child of the provided DisplayObjectContainer.
		 * @param If true, the loaded DisplayObject will replace all children on the target container.
		 * @param The loading context of the operation.
		 */
		public function DisplayObjectLoader(url:*, target:DisplayObjectContainer = null, replaceAllChildren:Boolean = false, context:LoaderContext = null) {
			super(url)
			this.target = target;
			this.replaceAllChildren = replaceAllChildren;
			loader = new Loader();			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, fail);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.load(this.url, context);
		}
		
		/** @private */
		override protected function complete(e:Event):void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
			content = loader.content;
			
			if(content is Bitmap) {
				(content as Bitmap).smoothing = true;
			}
			
			if(target) {
				target.addChild(e.target.content);
			}
			if(fadeInSpeed) {
				if(fadeInEffect) {
					fadeInEffect.target = e.target.content;
					fadeInEffect.targetAlpha = 0;
					fadeInEffect.fadeTargetIn(fadeInSpeed);
				} else {
					e.target.content.alpha = 0;
					new Tween(e.target.content, fadeInSpeed, {alpha:1});
				}
			}
			super.complete(e);
		}
		
		/** @private */
		override protected function removeLoaderEventListeners():void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, fail);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
		}
		
		/** @inheritDoc */
		override public function close():void {
			removeLoaderEventListeners();
			loader.close();
			super.close();
		}
		
		/** The DisplayObject of the loading operation. */
		override public function get result():* {
			return content;
		}
	}
	
}