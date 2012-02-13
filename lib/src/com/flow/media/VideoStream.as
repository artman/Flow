package com.flow.media {
	
	import com.flow.events.VideoStreamEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * Dispatched when the state of the VideoStream changes.
	 */	
	[Event(name="stateChange", type="com.flow.events.VideoStreamEvent")]
	
	/**
	 * Dispatched when the VideoStream has created a NetStream.
	 */	
	[Event(name="streamCreated", type="com.flow.events.VideoStreamEvent")]
	
	public class VideoStream extends EventDispatcher {
		
		private var _bufferTime:Number = 0;
		private var _metaData:Object;
		private var _netConnection:NetConnection;
		private var _playing:Boolean=false;
		private var _stream:NetStream;
		private var _source:String;
		private var _state:String;
		
		private var mediaURL:MediaURL;
		
		public function VideoStream(source:String = null) {
			state = VideoStreamState.STATE_INACTIVE;
			this.source = source;
		}
		
		public function get source():String {
			return _source;
		}
		public function set source(value:String):void {
			_source = value;
			if(_source) {
				mediaURL = new MediaURL(_source);
				if(mediaURL.isRTMP) {
					netConnection = new NetConnection();
					netConnection.connect(mediaURL.protocol + "://" + mediaURL.host + "/" + mediaURL.application);
				} else {
					throw new Error("Currently only RTMP streams are supported");
				}
			} else {
				netStream = null;
				netConnection = null;
			}
		}
		
		[Bindable]
		public function get state():String {
			return _state;
		}
		public function set state(value:String):void {
			_state = value;
			var evt:VideoStreamEvent = new VideoStreamEvent(VideoStreamEvent.STATE_CHANGE);
			evt.state = _state;
			dispatchEvent(evt);
		}
		
		
		[Bindable]
		public function get netConnection():NetConnection {
			return _netConnection
		}
		public function set netConnection(value:NetConnection):void {
			if(_netConnection) {
				_netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, netError);
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
			}
			_netConnection = value;
			if(_netConnection) {
				_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netError);
				_netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
				state = VideoStreamState.STATE_CONNECTING;
			}
		}
		
		private function netError(e:SecurityErrorEvent):void {
			var event:VideoStreamEvent = new VideoStreamEvent(VideoStreamEvent.CONNECTION_FAILED);
			event.errorID = e.errorID;
			event.description = e.text
			dispatchEvent(event)
		}
		
		private function netStatus(e:NetStatusEvent):void {
			if (e.info.code == "NetConnection.Connect.Success") {
				var event:VideoStreamEvent = new VideoStreamEvent(VideoStreamEvent.CONNECTED);
				dispatchEvent(event);
				startStream();
			} else if (e.info.code == "NetConnection.Connect.Failed" || e.info.code == "NetConnection.Connect.Rejected") {
				event = new VideoStreamEvent(VideoStreamEvent.CONNECTION_FAILED);
				event.code = e.info.code;
				event.description = e.info.description;
				dispatchEvent(event);
			}
		}
		
		public function get playing():Boolean{
			return _playing;
		}
		
		public function get bufferTime():Number{
			return _bufferTime;
		}
		public function set bufferTime(value:Number):void{
			_bufferTime = value;
		}
		
		public function get metaData():Object {
			return _metaData;
		}
		public function set metaData(value:Object):void {
			_metaData = value;
		}
		
		public function get time():Number {
			if(_stream) {
				return _stream.time;
			}
			return 0;
		}

		public function get duration():Number {
			if(metaData && metaData.duration != null) {
				return metaData.duration;
			}
			return 0;
		}

		public function play():void{
			if(_stream) {
				if(state == VideoStreamState.STATE_STOPPED) {
					_stream.play(mediaURL.stream);
				} else {
					_stream.resume();
				}
			}
		}
		
		public function pause():void{
			if(_stream) {
				_stream.pause();
			}
		}
		public function stop():void{
			if(_stream){
				_stream.close();
			}
		}
		public function seekTo(time:Number):void{
			if(_stream){
				time=Math.max(0, Math.min(time,duration));
				_stream.seek(time);
			}
		}
		
		public function seekToPercent(percent:Number):void{
			if(_stream){
				_stream.seek(Math.max(0, Math.min(percent,1)) * duration);
			}
		}
		
		private function startStream():void {
			netStream = new NetStream(netConnection);
			netStream.play(mediaURL.stream);
		}
		
		[Bindable]
		public function get netStream():NetStream {
			return _stream
		}
		public function set netStream(value:NetStream):void {
			if(_stream) {
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, streamNetStatus);
				_stream.removeEventListener(IOErrorEvent.IO_ERROR, streamError);
				_stream.removeEventListener(IOErrorEvent.NETWORK_ERROR, streamError);
			}
			_stream = value;
			if(_stream) {
				_stream.bufferTime = _bufferTime;
				_stream.client = new Object();
				_stream.client.onMetaData = onMetaData;
				_stream.client.onPlayStatus = onPlayStatus;
				_stream.addEventListener(NetStatusEvent.NET_STATUS, streamNetStatus);
				
				_stream.addEventListener(IOErrorEvent.IO_ERROR, streamError);
				_stream.addEventListener(IOErrorEvent.NETWORK_ERROR, streamError);
				var evt:VideoStreamEvent = new VideoStreamEvent(VideoStreamEvent.STREAM_CREATED);
				evt.netStream = _stream;
				dispatchEvent(evt);
			}
		}
		
		private function streamNetStatus(e:NetStatusEvent):void{
			trace(e.info.code);
			switch (e.info.code) {
				case "NetStream.Play.Reset":
					break;
				case "NetStream.Play.Start":
					state = VideoStreamState.STATE_PLAYING;
					break;
				case "NetStream.Pause.Notify":
					state = VideoStreamState.STATE_PAUSED;
					break;
				case "NetStream.Unpause.Notify":
					state = VideoStreamState.STATE_PLAYING;
					break;
				
				case "NetStream.Play.StreamNotFound":
					state = VideoStreamState.STATE_ERROR;
					break;
				
				case "NetStream.Buffer.Full":
					break;
				
				case "NetStream.Buffer.Empty":
					break;
				
				case "NetStream.Play.Failed":
					state = VideoStreamState.STATE_ERROR;
					break;
				
				case "NetStream.Seek.InvalidTime":
					break;
				
				case "NetStream.Buffer.Flush":
					break;
				
				case "NetStream.Play.Stop":
					break;
			}
		}
		
		private function onPlayStatus(data:Object):void {
			switch(data.code) {
				case "NetStream.Play.Complete":
					state = VideoStreamState.STATE_STOPPED;
					break;
			}
		}
		
		private function streamError(event:Event):void{
			_playing = false;
		}
		
		public function onMetaData(data:Object):void{
			if(!_metaData) {
				_metaData = data;
			}
		}
	}
}