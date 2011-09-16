package mx.states {
	
	import flash.events.EventDispatcher;
	
	public class OverrideBase extends EventDispatcher {
		
		protected function getOverrideContext(target:Object, parent:Object):Object {
			if (target == null) {
				return parent;
			}
			if (target is String) {
				return parent[target];
			}
			return target;
		}
		
		public function initializeFromObject(properties:Object):Object {
			try {
				for (var p:String in properties) {
					this[p] = properties[p];
				}
			} catch (e:Error) {}
			return Object(this);
		}
	}
}