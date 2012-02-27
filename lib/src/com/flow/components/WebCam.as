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
	import com.flow.log.Log;
	import com.flow.utils.GraphicUtils;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.media.Video;
	import flash.utils.Timer;

	/**
	 * Dispatched when the camera is muted (Flash has been removed access to use the camera by the user).
	 */	
	[Event(name="cameraMuted", type="com.flow.events.WebCamEvent")]
	
	/**
	 * Dispatched when the camera is unmuted (Flash has been granted access to use the camera by the user).
	 */	
	[Event(name="cameraUnmuted", type="com.flow.events.WebCamEvent")]
	
	/**
	 * Dispatched when a camera has been attached and a first frame has been received. 
	 */	
	[Event(name="cameraReady", type="com.flow.events.WebCamEvent")]
	public class WebCam extends Component {
		
		private var _video:Video;
		
		[Bindable]
		public var camera:Camera;
		
		[Bindable]
		public var microphone:Microphone;
		
		private var holder:Sprite;
		private var detectTimer:Timer;
		private var pixelateEffect:Effect;
		private var _mirror:Boolean = true;
		
		private var _cameraWidth:int = 800;
		private var _cameraHeight:int = 600;
		private var _frameRate:int = 25;
		
		private var _activeOffStage:Boolean = false;
		
		[Bindable]
		public var muted:Boolean = false;
		
		public function WebCam() {
			super();
			holder = new Sprite();
			addChild(holder);
			
			video = new Video(800,600);
			video.visible = false;
			addEventListener(Event.ADDED_TO_STAGE, added);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
			detectTimer = new Timer(100);
			detectTimer.addEventListener(TimerEvent.TIMER, checkCamera);
		}
		
		public function get activeOffStage():Boolean {
			return _activeOffStage;
		}
		public function set activeOffStage(value:Boolean):void {
			if(value != _activeOffStage) {
				_activeOffStage = value;
				if(_activeOffStage) {
					removeEventListener(Event.ADDED_TO_STAGE, added);
					removeEventListener(Event.REMOVED_FROM_STAGE, removed);
					if(!camera) {
						added();
					}
				} else {
					addEventListener(Event.ADDED_TO_STAGE, added);
					addEventListener(Event.REMOVED_FROM_STAGE, removed);
					if(camera) {
						removed();
					}
				}
			}
		}
		
		private function get video():Video {
			return _video;
		}
		private function set video(value:Video):void {
			if(_video != value) {
				var vis:Boolean = false;
				if(_video) {
					vis = _video.visible;
					holder.removeChild(_video)
				}
				_video = value;
				_video.smoothing = true;
				_video.visible = vis;
				holder.addChild(video);
			}
		}
		
		[Bindable]
		public function get cameraWidth():int {
			return _cameraWidth;
		}
		public function set cameraWidth(value:int):void {
			_cameraWidth = value;
			setCameraMode();
		}

		[Bindable]
		public function get cameraHeight():int {
			return _cameraHeight;
		}
		public function set cameraHeight(value:int):void {
			_cameraHeight = value;
			setCameraMode();
		}
		
		[Bindable]
		public function get frameRate():int {
			return _frameRate;
		}
		public function set frameRate(value:int):void {
			_frameRate = value;
			setCameraMode();
		}

		private function setCameraMode():void {
			if(camera) {
				camera.setMode(cameraWidth, cameraHeight, frameRate, false);
				video = new Video(cameraWidth, cameraHeight);
				video.clear();
				video.attachCamera(camera);
				invalidate();
			}
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
		
		private function added(e:Event = null):void {
			camera = Camera.getCamera();
			microphone = Microphone.getMicrophone();
			
			/*microphone.rate = 44;
			microphone.setSilenceLevel(0);
			microphone.codec = SoundCodec.SPEEX;
			microphone.encodeQuality = 5;
			microphone.framesPerPacket = 2
			*/
			camera.setMotionLevel( 100 );
			camera.setQuality(50000, 0);
			camera.setKeyFrameInterval(25);
			if(camera) {
				camera.addEventListener(StatusEvent.STATUS, cameraStatus);
				setCameraMode();
				
				video.visible = false;
				if(!camera.muted) {
					detectTimer.start();
				}
			}
			invalidate();
		}
		
		private function removed(e:Event = null):void {
			video.attachCamera(null);
			video.visible = false;
			camera = null;
			microphone = null;
		}
		
		override public function draw(width:Number, height:Number):void {
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
					video.height = Math.round(width / aspect)
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
			dispatchEvent(new WebCamEvent(WebCamEvent.CAMERA_READY));
		}
		
		public function get pictureAvailable():Boolean {
			return video.visible;
		}
	}
}




	