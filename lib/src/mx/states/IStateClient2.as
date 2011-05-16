package mx.states {
	
	import flash.events.IEventDispatcher;
	
	public interface IStateClient2 {   
		function get states():Array;
		function set states(value:Array):void;
		function get transitions():Array;
		function set transitions(value:Array):void;
		function hasState(stateName:String):Boolean;
		function get currentState():String;
		function set currentState(value:String):void;
	}
}
