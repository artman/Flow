package com.flow.containers {
	import com.flow.collections.IList;
	import com.flow.components.Component;
	import com.flow.containers.layout.LayoutBase;
	import com.flow.containers.layout.VBoxLayout;
	import com.flow.events.CollectionEvent;
	import com.flow.events.ListEvent;
	
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	
	
	[DefaultProperty("itemRenderer")]
	[Event(name="rendererCreated", type="com.flow.events.ListEvent")]
	[Event(name="selectionChanged", type="com.flow.events.ListEvent")]
	[Event(name="itemsCreated", type="com.flow.events.ListEvent")]
	public class List extends Container {
		
		private var _dataProvider:*;
		private var _itemRenderer:IFactory;
		private var _selectedIndex:int = -1;
		private var _selectedItem:Object;
		
		public function List() {
			super();
		}
		
		override protected function getDefaultLayout():LayoutBase {
			var layout:VBoxLayout = new VBoxLayout();
			layout.verticalAlign = "top";
			return layout;
		}
		
		[Bindable]
		public function get dataProvider():* {
			return _dataProvider;
		}
		public function set dataProvider(value:*):void {
			if(_dataProvider && _dataProvider is IList) {
				(_dataProvider as IList).removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChanged);
				selectedIndex = -1;
			}			
			_dataProvider = value;
			invalidateProperties();
			if(_dataProvider && _dataProvider is IList) {
				(_dataProvider as IList).addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChanged);
			}
		}
		
		private function collectionChanged(e:CollectionEvent):void {
			invalidateProperties();
		}
		
		private function removeItemRenderers():void {
			if(children && children.length) {
				var n:int = children.length;
				while(--n > -1) {
					(children.getItemAt(n) as Component).removeEventListener(MouseEvent.CLICK, rendererClicked);
				}
				children.removeAll();
			}
		}
		
		override public function validateProperties():void {
			super.validateProperties();
			if(_dataProvider && _itemRenderer) {
				removeItemRenderers();
				
				var data:* = _dataProvider;
				if(data is IList) {
					data = (data as IList).toArray();
				}
				
				if(data is Array || data is Vector.<*>) {
					var i:int = 0;
					var n:int = data.length;
					var renderer:Component;
					for(; i<n; ++i) {
						renderer = _itemRenderer.newInstance();
						renderer.data = data[i];
						renderer.rendererIndex = i;
						
						var evt:ListEvent = new ListEvent(ListEvent.RENDERER_CREATED);
						evt.renderer = renderer;
						dispatchEvent(evt);
						
						renderer.interactive = true;
						renderer.addEventListener(MouseEvent.CLICK, rendererClicked);
						children.addItem(renderer);
					}
					if(_selectedIndex != -1) {
						renderer = children.getItemAt(_selectedIndex) as Component;
						if(renderer) {
							renderer.addState("selected");
						}
						if(_dataProvider is IList) {
							selectedItem = (_dataProvider as IList).getItemAt(_selectedIndex);
						} else {
							selectedItem = _dataProvider[_selectedIndex];
						}
					}
				}
			} else {
				removeItemRenderers();
			}
			dispatchEvent(new ListEvent(ListEvent.ITEMS_CREATED));
		}
		
		protected function rendererClicked(event:MouseEvent):void {
			selectedIndex = children.getItemIndex(event.currentTarget);
		}
		
		
		public function get itemRenderer():IFactory {
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void {
			if(value != _itemRenderer) {
				_itemRenderer = value;
				invalidateProperties();
			}
		}
		
		[Bindable]
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			if(_selectedIndex != -1 && !propertiesInvalidated) {
				(children.getItemAt(_selectedIndex) as Component).removeState("selected");
			}
			_selectedIndex = value;
			if(_selectedIndex != -1) {
				if(_dataProvider is Array || _dataProvider is Vector.<*>) {
					selectedItem = _dataProvider[_selectedIndex];
				} else if(_dataProvider is IList) {
					selectedItem = (_dataProvider as IList).getItemAt(_selectedIndex);
				}
				if(!propertiesInvalidated) {
					(children.getItemAt(_selectedIndex) as Component).addState("selected");
				}
			} else {
				selectedItem = null;
			}
			dispatchEvent(new ListEvent(ListEvent.SELECTION_CHANGED));
		}
		
		
		[Bindable]
		public function get selectedItem():Object {
			return _selectedItem;
		}
		public function set selectedItem(value:Object):void {
			_selectedItem = value;
		}
	}
}