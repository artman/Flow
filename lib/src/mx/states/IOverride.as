package mx.states {
	
	public interface IOverride {
		function initialize():void;
		function apply(parent:Object):void;
		function remove(parent:Object):void;
	}
}