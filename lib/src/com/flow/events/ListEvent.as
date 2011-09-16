package com.flow.events {
	import com.flow.components.Component;
	
	import flash.events.Event;
	
	public class ListEvent extends Event {
		
		public static const RENDERER_CREATED:String = "rendererCreated";
		public static const SELECTION_CHANGED:String = "selectionChanged";
		
		public var renderer:Component;
		
		public function ListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}