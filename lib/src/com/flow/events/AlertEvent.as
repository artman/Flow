package com.flow.events {
	import flash.events.Event;
	
	public class AlertEvent extends Event {
		
		public static var ALERT_DISMISSED:String = "alertDismissed";
		
		public var buttonIndex:int;
		
		public function AlertEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}