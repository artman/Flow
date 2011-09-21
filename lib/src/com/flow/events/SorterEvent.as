package com.flow.events {
	
	import flash.events.Event;
	
	public class SorterEvent extends Event {
		
		public static const SORTING_CHANGED:String = "sortingChanged";
		
		public function SorterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}