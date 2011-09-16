package mx.states {
	
	import com.flow.collections.IList;
	import com.flow.components.Component;
	
	import mx.core.DeferredInstanceFromFunction;

	public class AddItems extends OverrideBase implements IOverride { 
		
		static public const FIRST:String = "first";
		static public const BEFORE:String = "before";
		static public const AFTER:String = "after";
		static public const LAST:String = "last";
		
		public var itemsFactory:*;
		public var destination:*;
		public var propertyName:String;
		public var position:String;
		public var relativeTo:Array = [];
		
		private var item:*;
		
		public function initialize():void {
		}
		
		public function apply(parent:Object):void {
			var object:* = getOverrideContext(destination, parent);
			item = (itemsFactory as DeferredInstanceFromFunction).getInstance();
			if(object[propertyName] is IList) {
				applyToList(parent, object, item);
			}
		}
		
		public function remove(parent:Object):void {
			var object:* = getOverrideContext(destination, parent);
			if(object[propertyName] is IList) {
				removeFromList(parent, object, item);
			}
			item = null;
		}
		
		private function applyToList(parent:Object, object:*, item:*):void {
			var index:int = getInsertIndex(parent, position, object);
			var itemIndexInList:int = (object[propertyName] as IList).getItemIndex(item);
			if(itemIndexInList == -1) {
				(object[propertyName] as IList).addItemAt(item, index);
			}
			//if(item is Component) {
			//	(item as Component).active = true;
			//}
		}
		
		private function removeFromList(parent:Object, object:*, item:*):void {
			var index:int = (object[propertyName] as IList).getItemIndex(item);
			//if(item is Component) {
			//	(item as Component).active = false;
			//} else {
				(object[propertyName] as IList).removeItemAt(index);
			//}
		}
		
		private function getInsertIndex(parent:Object, position:String, dest:*):int {
			switch(position) {
				case FIRST: return 0;
				case LAST: return (dest[propertyName] as IList).length;
				case AFTER: return getRelatedIndex(parent, dest)+1;
				case BEFORE: return getRelatedIndex(parent, dest);
			}
			return -1;
		}
		
		private function getRelatedIndex(parent:Object, object:Object):int {
			if(relativeTo is Array) {
				for(var i:int = 0; i < relativeTo.length; i++) {
					if(parent[relativeTo[i]]) {
						return getObjectIndex(parent[relativeTo[i]], object);
					}
				}
			
			}
			return -1;
		}
		
		private function getObjectIndex(child:Object, parent:Object):int {
			if(parent[propertyName] is IList) {
				return (parent[propertyName] as IList).getItemIndex(child);
			}
			return -1;
		}
	}
}