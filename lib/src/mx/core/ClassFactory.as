
package mx.core {

	public class ClassFactory implements IFactory {
		public function ClassFactory(generator:Class = null) {
			super();
			
			this.generator = generator;
		}
		
		public var generator:Class;
		public var properties:Object = null;
		
		public function newInstance():* {
			var instance:Object = new generator();	
			if (properties != null) {
				for (var p:String in properties) {
					instance[p] = properties[p];
				}
			}
			return instance;
		}
	}
}
