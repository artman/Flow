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
	
	import com.flow.components.supportClasses.SkinnableComponent;
	import com.flow.containers.Container;
	import com.flow.events.VideoStreamEvent;
	import com.flow.media.MediaURL;
	import com.flow.media.VideoStream;
	import com.flow.media.VideoStreamState;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.utils.Timer;
	
	import mx.states.State;
	
	[SkinState("inactive")]
	[SkinState("connecting")]
	[SkinState("buffering")]
	[SkinState("playing")]
	[SkinState("paused")]
	[SkinState("stopped")]
	[SkinState("error")]
	
	public class VideoPlayer extends SkinnableComponent {
		public static const DEFAULT_VOLUME:Number = 0.75
		
		private var video:Video;
		private var holder:Sprite;
		
		private var _videoContainer:Container;
		private var _playPauseToggleButton:Button;
		private var _source:String;
		private var _keepAspectRatio:Boolean = true;
		private var _smoothing:Boolean = true;
		private var videoStream:VideoStream;
		private var _progressSlider:HSlider;
		private var _volumeSlider:HSlider;
		
		[Bindable]
		public var showControls:Boolean = true;
		
		private var ignoreSliderChange:Boolean = false;
		private var hideTimer:Timer;
		private var _crop:Boolean = false;

		public function VideoPlayer() {
			super();
			states = [
				new State("inactive"),
				new State("connecting"),
				new State("buffering"),
				new State("playing"),
				new State("paused"),
				new State("error")
			];
			video = new Video(400,300);
			video.smoothing = _smoothing;
			addEventListener(MouseEvent.ROLL_OVER, mouseOver);
			addEventListener(MouseEvent.ROLL_OUT, mouseOut);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			hideTimer = new Timer(2000, 1);
			hideTimer.addEventListener(TimerEvent.TIMER, hideTimerTick);
		}
		
		public function get playbackTime():Number {
			if(videoStream) {
				return videoStream.time;
			}
			return 0;
		}
		
		protected function hideTimerTick(event:TimerEvent):void {
			showControls = false;
		}
		
		private function mouseOver(e:MouseEvent):void {
			hideTimer.start();
		}
		
		private function mouseOut(e:MouseEvent):void {
			showControls = false;
		}
		
		private function mouseMove(e:MouseEvent):void {
			if(new Rectangle(0,0,width, height).contains(e.localX, e.localY)) {
				showControls = true;
				hideTimer.reset();
				hideTimer.start();
			} else {
				showControls = false;
				hideTimer.stop();
			}
		}
		
		/**
		 * A container where the video will be placed. The container's children will be replaced with the video.
		 */		
		[SkinPart(required="true")]
		public function get videoContainer():Container {
			return _videoContainer;
		}
		public function set videoContainer(value:Container):void {
			_videoContainer = value;
			_videoContainer.addChild(video);
			_videoContainer.clip = true;
			invalidateLayout();
		}
		
		/**
		 * Play pause toggle button. The button should toggle itself to play/pause depending on the component's state.
		 */		
		[SkinPart(required="false")]
		public function get playPauseToggleButton():Button {
			return _playPauseToggleButton;
		}
		public function set playPauseToggleButton(value:Button):void {
			if(_playPauseToggleButton) {
				_playPauseToggleButton.removeEventListener(MouseEvent.CLICK, togglePlayPause);
			}
			_playPauseToggleButton = value;
			if(_playPauseToggleButton) {
				_playPauseToggleButton.addEventListener(MouseEvent.CLICK, togglePlayPause);
			}
		}
		
		/**
		 * Play pause toggle button. The button should toggle itself to play/pause depending on the component's state.
		 */		
		[SkinPart(required="false")]
		public function get progressSlider():HSlider {
			return _progressSlider;
		}
		public function set progressSlider(value:HSlider):void {
			if(value != _progressSlider) {
				if(_progressSlider) {
					_progressSlider.removeEventListener(Event.CHANGE, progressSliderChanged);
				}
				_progressSlider = value;
				_progressSlider.minimum = 0;
				_progressSlider.maximum = 1;
				_progressSlider.addEventListener(Event.CHANGE, progressSliderChanged);
				updatePlaybackHead();
			}
		}
		
		protected function progressSliderChanged(event:Event):void {
			if(!ignoreSliderChange) {
				videoStream.seekToPercent(_progressSlider.value);
			}
		}
		
		/**
		 * Play pause toggle button. The button should toggle itself to play/pause depending on the component's state.
		 */		
		[SkinPart(required="false")]
		public function get volumeSlider():HSlider {
			return _volumeSlider;
		}
		public function set volumeSlider(value:HSlider):void {
			if(value != _volumeSlider) {
				if(_volumeSlider) {
					_volumeSlider.removeEventListener(Event.CHANGE, changeVolume);
				}
				_volumeSlider = value;
				_volumeSlider.minimum = 0;
				_volumeSlider.maximum = 1;
				_volumeSlider.value = videoStream ? videoStream.volume : DEFAULT_VOLUME;
				_volumeSlider.addEventListener(Event.CHANGE, changeVolume);
			}
		}
		
		protected function changeVolume(event:Event = null):void {
			if(video) {				
				videoStream.volume = _volumeSlider ? _volumeSlider.value : 1;
			}
		}
		
		protected function togglePlayPause(event:MouseEvent):void {
			if(videoStream) {
				if(videoStream.state == VideoStreamState.STATE_PAUSED || videoStream.state == VideoStreamState.STATE_STOPPED) {
					videoStream.play();
				} else if(videoStream.state == VideoStreamState.STATE_PLAYING || videoStream.state == VideoStreamState.STATE_BUFFERING) {
					videoStream.pause();
				}
			}
		}
		
		/**
		 * The video source URL. 
		 */	
		[Bindable]
		public function get source():String {
			return _source;
		}
		public function set source(value:String):void {
			_source = value;
			if(_source) {
				currentState = "connecting";
				var url:MediaURL = new MediaURL(_source);
				if(url.isRTMP) {
					videoStream = new VideoStream(_source);
					videoStream.addEventListener(VideoStreamEvent.STATE_CHANGE, streamStateChange);
					videoStream.addEventListener(VideoStreamEvent.STREAM_CREATED, streamCreated);
					//videoStream.addEventListener(VideoStreamEvent.STREAM_CREATED, streamCreated);
				} else {
					throw new Error("VideoPlayer currently supports only RTMP streams.");
				}
			} else {
				currentState = "inactive";
			}
		}
		
		protected function streamCreated(event:VideoStreamEvent):void {
			video.attachNetStream(event.netStream);
		}
		
		protected function streamStateChange(event:VideoStreamEvent):void {
			removeEventListener(Event.ENTER_FRAME, updatePlaybackHead);
			switch(event.state) {
				case VideoStreamState.STATE_INACTIVE:
					currentState = "inactive"; 
					break;
				case VideoStreamState.STATE_CONNECTING:
					currentState = "connecting"; 
					break;
				case VideoStreamState.STATE_BUFFERING: 
					currentState = "buffering"; 
					break;
				case VideoStreamState.STATE_PLAYING: 
					currentState = "playing"; 
					addEventListener(Event.ENTER_FRAME, updatePlaybackHead);
					break;
				case VideoStreamState.STATE_PAUSED:
					currentState = "paused"; 
					break;
				case VideoStreamState.STATE_ERROR:
					currentState = "error"; 
					break;
				case VideoStreamState.STATE_STOPPED:
					currentState = "stopped"; 
					updatePlaybackHead();
					break;
			}
			invalidate();
		}
		
		protected function updatePlaybackHead(e:Event = null):void {
			if(_progressSlider && videoStream && videoStream.duration) {
				ignoreSliderChange = true
				_progressSlider.value = videoStream.time / videoStream.duration;
				ignoreSliderChange = false;
				invalidate();
			}
		}
		
		/**
		 * Whether to keep the video's aspect ratio or scale according to container size. 
		 */	
		public function get keepAspectRatio():Boolean {
			return _keepAspectRatio;
		}
		public function set keepAspectRatio(value:Boolean):void {
			if(value != _keepAspectRatio) {
				_keepAspectRatio = value;
				invalidate();
			}
		}
		
		/**
		 * Whether to crop the overflowing video or show everything
		 */
		public function get crop():Boolean {
			return _crop;
		}
		public function set crop(value:Boolean):void {
			if(value != _crop) {
				_crop = value;
				invalidate();
			}
		}
		
		
		/**
		 * Whether to enable smoothing on the video.
		 */	
		public function get smoothing():Boolean {
			return _smoothing;
		}
		public function set smoothing(value:Boolean):void {
			if(value != _smoothing) {
				_smoothing = value;
				video.smoothing = _smoothing;
			}
		}
		
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
			if(video.videoWidth && video.videoHeight && _keepAspectRatio) {
				var aspect:Number = video.videoWidth / video.videoHeight;
				var viewAspect:Number = videoContainer.width / videoContainer.height;
				
				
				if((viewAspect < aspect && crop) || (viewAspect > aspect && !crop)) {
					video.height = height;
					video.width = Math.round(height * aspect);
				} else {
					video.width = width;
					video.height = Math.round(width / aspect)
				}				
				var offsetX:int = (video.width - videoContainer.width) / 2;
				var offsetY:int = (video.height - videoContainer.height) / 2;
				video.x = -offsetX;
				video.y = -offsetY;
			} else {
				video.x = video.y = 0;
				video.width = videoContainer.width;
				video.height = videoContainer.height;
			}
		}
	}
}




