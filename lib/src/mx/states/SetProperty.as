package mx.states {
	
	import flash.display.DisplayObject;

	public class SetProperty extends OverrideBase implements IOverride { 
		
		public var name:String;
		public var target:String;
		public var value:*;
		
		private var oldValue:*;
		
		public function initialize():void {
		}
		
		public function apply(parent:Object):void {
			if(parent == null) { 
				return; 
			}
			if(target) {
				var item:Object = parent[target];
			} else {
				item = parent;
			}
			if(item == null) { 
				return; 
			}
			oldValue = item[name];
			item[name] = value;
		}
		
		public function remove(parent:Object):void {
			if(parent == null) { 
				return;
			}
			if(target) {
				var item:Object = parent[target];
			} else {
				item = parent;
			}
			if(item == null) { 
				return;
			}
			item[name] = oldValue;
			oldValue = null;
		}
	}
}