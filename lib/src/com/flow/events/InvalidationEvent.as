package com.flow.events
{
	import flash.events.Event;
	
	public class InvalidationEvent extends Event {
		
		public static var INVALIDATE:String = "invalidate";
		public static var INVALIDATE_LAYOUT:String = "invalidateLayout";
		
		public function InvalidationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}