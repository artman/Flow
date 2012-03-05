
package mx.core {

	public class DeferredInstanceFromFunction /*implements ITransientDeferredInstance*/ {

		public function DeferredInstanceFromFunction(generator:Function, destructor:Function = null) {
			super();
			this.generator = generator;
			this.destructor = destructor;
		}

		private var generator:Function;
		private var instance:Object = null;
		private var destructor:Function;

		public function getInstance():Object {
			if (!instance)
				instance = generator();
			return instance;
		}
		
		public function reset():void {
			instance = null;
			if (destructor != null) {
				destructor();
			}
		}
	}
}
