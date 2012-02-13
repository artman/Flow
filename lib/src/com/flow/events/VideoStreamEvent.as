package com.flow.events {
	
	import flash.events.Event;
	import flash.net.NetStream;
	
	public class VideoStreamEvent extends Event {
		
		public static const CONNECTED:String="connected";
		public static const CONNECTION_FAILED:String="connectionFailed";
		public static const STATE_CHANGE:String="stateChange";
		public static const PROGRESS:String="progress";
		public static const STREAM_CREATED:String="streamCreated";
		
		public var errorID:int;
		public var code:String;
		public var description:String;
		public var state:String;
		public var netStream:NetStream;
		
		public function VideoStreamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}