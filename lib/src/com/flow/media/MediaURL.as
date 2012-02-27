package com.flow.media {
	
	public class MediaURL {
		
		private var _url:String;
		private var _protocol:String;
		private var _host:String;
		private var _application:String;
		private var _stream:String;
		
		public function MediaURL(url:String):void {
			_url = url;
			parseURL();
		}
		
		[Bindable]
		public function get url():String {
			return _url
		}
		private function set url(value:String):void {
			_url = value;
			parseURL();
		}
		
		public function get protocol():String {
			return _protocol;
		}
		
		public function get host():String {
			return _host;
		}
		
		public function get application():String {
			return _application;
		}
		
		public function get stream():String {
			return _stream;
		}
		
		public function get isRTMP():Boolean {
			if(!protocol) {
				return false
			};
			var protocols:Array = ["rtmp", "rtmpe", "rtmps", "rtmpt", "rtmfp"];
			if(protocols.indexOf(protocol) != -1) {
				return true;
			}
			return false
		}
		
		private function parseURL():void {
			_protocol = null;
			_application = null;
			_host = null;
			_stream = null;
			
			if(_url) {
				if(_url.indexOf("://") == -1) {
					throw new Error("Media url has no protocol");
				}
				var split:Array = _url.split("://");
				_protocol = split.shift();
				split = split.join("://").split("/");
				_host = split.shift();
				
				if(isRTMP && split.length) {
					_application = split.shift();
					if(split.length) {
						if(split.length > 1) {
							_application = _application + "/" + split.shift();
							_stream = split.join("/");
						} else {
							_stream = split[0]
						}
					} else {
						_stream = _application;
						_application = null;
						
					}
				} else {
					_application = null;
				}
			}
		}
	}	
}