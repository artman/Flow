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
	
	import com.flow.effects.Effect;
	import com.flow.effects.PixelateEffect;
	import com.flow.events.WebCamEvent;
	import com.flow.utils.GraphicUtils;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;

	[Event(name="cameraMuted", type="com.flow.events.WebCamEvent")]
	[Event(name="cameraUnmuted", type="com.flow.events.WebCamEvent")]
	[Event(name="cameraReady", type="com.flow.events.WebCamEvent")]
	public class WebCam extends Component {
		
		private var video:Video;
		public var camera:Camera;
		private var holder:Sprite;
		private var detectTimer:Timer;
		private var effect:Effect;
		private var _mirror:Boolean = true;
		
		[Bindable]
		public var muted:Boolean = false;
		
		public function WebCam() {
			super();
			holder = new Sprite();
			addChild(holder);
			
			video = new Video(800,600);
			video.smoothing = true;
			video.visible = false;
			
			effect = new PixelateEffect(video, 20);
			effect.value = 0;
			
			holder.addChild(video);
			addEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			detectTimer = new Timer(100);
			detectTimer.addEventListener(TimerEvent.TIMER, checkCamera);
		}
		
		public function get mirror():Boolean {
			return _mirror;
		}
		public function set mirror(value:Boolean):void {
			if(value != _mirror) {
				_mirror = value;
				invalidate();
			}
		}
		
		private function added(e:Event):void {
			camera = Camera.getCamera();
			if(camera) {
				camera.addEventListener(StatusEvent.STATUS, cameraStatus);
				camera.setMode(800,600,45,true);
				video.clear();
				video.attachCamera(camera);
				video.visible = false;
				if(!camera.muted) {
					detectTimer.start();
				}
			}
			invalidate();
		}
		
		private function removed(e:Event):void {
			video.attachCamera(null);
			video.visible = false;
			camera = null;
		}
		
		override public function draw(width:int, height:int):void {
			super.draw(width, height);
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0,0,width, height);
			graphics.endFill();
			if(camera) {
				var aspect:Number = camera.width / camera.height;
				var viewAspect:Number = width / height;
				if(viewAspect < aspect) {
					video.height = height;
					video.width = Math.round(height * aspect);
				} else {
					video.width = width;
					video.height = Math.round(width/aspect)
				}
				
				var offsetX:int = (video.width - width) / 2;
				var offsetY:int = (video.height - height) / 2;
				holder.scrollRect = new Rectangle(0, 0, width, height);
			
				video.x = -offsetX;
				video.y = -offsetY;
				
				if(_mirror) {
					video.x += video.width;
					video.scaleX = -video.scaleX;
				}
			}
		}
		
		public function getSnapShot(w:int=0, h:int=0, mirrorSnapshot:Boolean=false):BitmapData {
			if(!w) {
				w = video.width;
			}
			if(!h) {
				h = video.height;
			}
			var bmp:BitmapData = GraphicUtils.draw(video, w, h);
			if(mirrorSnapshot){
				bmp = GraphicUtils.flipHorizontally(bmp);
			}
			return bmp;
		}
		
		private function checkCamera(event:TimerEvent):void {
			var bmp:BitmapData = new BitmapData( 320, 240, true, 0 );
			bmp.draw(video);
			
			for(var i:int = 0; i<50; i++) {
				if(bmp.getPixel32(Math.round(Math.random()*320), Math.round(Math.random()*240)) != 0) {
					detectTimer.stop();
					cameraAvailable();
					return;
				}
			}	
		}

		private function cameraStatus(event:StatusEvent):void {
			if( event.code == "Camera.Unmuted" )  {
				detectTimer.start();
				muted = false;
				dispatchEvent(new WebCamEvent(WebCamEvent.CAMERA_UNMUTED));
			} 
				// Access denied
			else if( event.code == "Camera.Muted" )  {
				detectTimer.stop();
				muted = true;
				dispatchEvent(new WebCamEvent(WebCamEvent.CAMERA_MUTED));
			}
		}
		
		private function cameraAvailable():void {
			video.visible = true;
			effect.targetAlpha = 0;
			effect.fadeTargetIn(0.6);
			dispatchEvent(new WebCamEvent(WebCamEvent.CAMERA_READY));
		}
		
		public function get pictureAvailable():Boolean {
			return video.visible;
		}
	}
}




	