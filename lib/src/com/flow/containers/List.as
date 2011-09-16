package com.flow.containers {
	import com.flow.collections.IList;
	import com.flow.components.Component;
	import com.flow.containers.layout.LayoutBase;
	import com.flow.containers.layout.VBoxLayout;
	import com.flow.events.ListEvent;
	
	[DefaultProperty("renderer")]
	[Event(name="rendererCreated", type="com.flow.events.ListEvent")]
	public class List extends Container {
		
		private var _dataProvider:*;
		private var _renderer:Class;
		
		public function List() {
			super();
		}
		
		override protected function getDefaultLayout():LayoutBase {
			return new VBoxLayout();
		}
		
		public function get dataProviver():* {
			return _dataProvider;
		}
		public function set dataProvider(value:*):void {
			if(value != _dataProvider) {
				_dataProvider = value;
				invalidateProperties();
			}
		}
		
		override public function validateProperties():void {
			if(_dataProvider && _renderer) {
				children.removeAll();
				if(_dataProvider is Array || _dataProvider is Vector.<*>) {
					for(var i:int = 0; i<_dataProvider.length; i++) {
						var renderer:Component = new _renderer();
						renderer.data = _dataProvider[i];
						
						var evt:ListEvent = new ListEvent(ListEvent.RENDERER_CREATED);
						evt.renderer = renderer;
						dispatchEvent(evt);
						
						children.addItem(renderer);
					}
				}
			} else {
				children.removeAll();
			}
		}

		public function get renderer():Class {
			return _renderer;
		}

		public function set renderer(value:Class):void {
			if(value != _renderer) {
				_renderer = value;
			}
		}

	}
}