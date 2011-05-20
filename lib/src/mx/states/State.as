package mx.states {
	
	import flash.events.EventDispatcher;
	
	[DefaultProperty("overrides")]	
	public class State extends EventDispatcher {
		private var initialized:Boolean = false;
		public var name:String;		
		public var overrides:Array = [];
		
		public function State(properties:Object=null) {
			super();
			if(properties is String) {
				name = properties as String;
			} else {
				for (var p:String in properties) {
					this[p] = properties[p];
				}
			}
		}
		
		public function initialize():void {
			if (!initialized) {
				initialized = true;
				for (var i:int = 0; i < overrides.length; i++) {
					IOverride(overrides[i]).initialize();
				}
			} 
		} 
		
		public function apply(target:Object):void {
			for (var i:int = 0; i < overrides.length; i++) {
				IOverride(overrides[i]).apply(target);
			}
		}
		
		public function remove(target:Object):void {
			for (var i:int = 0; i < overrides.length; i++) {
				IOverride(overrides[i]).remove(target);
			}
		}
	}
}
