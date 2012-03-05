
package mx.core {
	

	public class DeferredInstanceFromClass /*implements ITransientDeferredInstance*/ {

		public function DeferredInstanceFromClass(generator:Class) {
			super();
			this.generator = generator;
		}
		
		private var generator:Class;
		private var instance:Object = null;
		
	
		public function getInstance():Object {
			if (!instance) {
				instance = new generator();
			}
			return instance;
		}

		public function reset():void {
			instance = null;
		}
	}
}
