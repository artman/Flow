package com.flow.containers {
	import com.flow.collections.IList;
	import com.flow.components.Component;
	import com.flow.containers.layout.LayoutBase;
	import com.flow.containers.layout.VBoxLayout;
	import com.flow.events.ListEvent;
	
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	
<<<<<<< HEAD
<<<<<<< HEAD
	
	
	[DefaultProperty("renderer")]
=======
=======

>>>>>>> Merged with origin
	[DefaultProperty("itemRenderer")]
>>>>>>> Added IFactory, modified List to use IFactory.
	[Event(name="rendererCreated", type="com.flow.events.ListEvent")]
	[Event(name="selectionChanged", type="com.flow.events.ListEvent")]
	public class List extends Container {
		
		private var _dataProvider:*;
<<<<<<< HEAD
		private var _renderer:IFactory;
=======
		private var _itemRenderer:IFactory;
>>>>>>> Added IFactory, modified List to use IFactory.
		private var _selectedIndex:int = -1;
		private var _selectedItem:Object;
		
		public function List() {
			super();
		}
		
		override protected function getDefaultLayout():LayoutBase {
			return new VBoxLayout();
		}
		
		[Bindable]
		public function get dataProvider():* {
			return _dataProvider;
		}
		public function set dataProvider(value:*):void {
			if(value != _dataProvider) {
				_dataProvider = value;
				invalidateProperties();
			}
		}
		
		override public function validateProperties():void {
			if(_dataProvider && _itemRenderer) {
				if(children && children.length) {
					for(var i:int = 0; i<children.length; i++) {
						(children.getItemAt(i) as Component).removeEventListener(MouseEvent.CLICK, rendererClicked);
					}
				}
				children.removeAll();
<<<<<<< HEAD
				if(_dataProvider is Array || _dataProvider is Vector.<*>) {
					for(i = 0; i<_dataProvider.length; i++) {
<<<<<<< HEAD
						var renderer:Component = _renderer.newInstance();
=======
						var renderer:Component = _itemRenderer.newInstance();
>>>>>>> Added IFactory, modified List to use IFactory.
						renderer.data = _dataProvider[i];
=======
				var data:* = _dataProvider;
				if(data is IList) {
					data = (data as IList).toArray();
				}

				if(data is Array || data is Vector.<*>) {
					for(i = 0; i<data.length; i++) {
						var renderer:Component = _itemRenderer.newInstance();
						renderer.data = data[i];
						renderer.rendererIndex = i;
>>>>>>> Whole set of examples on layout
						
						var evt:ListEvent = new ListEvent(ListEvent.RENDERER_CREATED);
						evt.renderer = renderer;
						dispatchEvent(evt);
						
						renderer.interactive = true;
						renderer.addEventListener(MouseEvent.CLICK, rendererClicked);
						children.addItem(renderer);
					}
					if(_selectedIndex != -1) {
						(children.getItemAt(_selectedIndex) as Component).addState("selected");
						selectedItem = _dataProvider[_selectedIndex];
					}
				}
			} else {
				children.removeAll();
			}
		}
		
		protected function rendererClicked(event:MouseEvent):void {
			selectedIndex = children.getItemIndex(event.currentTarget);
		}
		
<<<<<<< HEAD
<<<<<<< HEAD
		

		public function get itemRenderer():IFactory {
			return _renderer;
		}
		public function set itemRenderer(value:IFactory):void {
			if(value != _renderer) {
				_renderer = value;
=======
=======

>>>>>>> Merged with origin
		public function get itemRenderer():IFactory {
			return _itemRenderer;
		}
		public function set itemRenderer(value:IFactory):void {
			if(value != _itemRenderer) {
				_itemRenderer = value;
>>>>>>> Added IFactory, modified List to use IFactory.
				invalidateProperties();
			}
		}

		[Bindable]
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			if(value != _selectedIndex) {
				if(_selectedIndex != -1 && !propertiesInvalidated) {
					(children.getItemAt(_selectedIndex) as Component).removeState("selected");
				}
				_selectedIndex = value;
				if(_dataProvider is Array || _dataProvider is Vector.<*>) {
					selectedItem = _dataProvider[_selectedIndex];
				}
				if(!propertiesInvalidated) {
					(children.getItemAt(_selectedIndex) as Component).addState("selected");
				}
				dispatchEvent(new ListEvent(ListEvent.SELECTION_CHANGED));
			}
		}
<<<<<<< HEAD
		
		
		
		
		
=======

>>>>>>> Merged with origin
		[Bindable]
		public function get selectedItem():Object {
			return _selectedItem;
		}
		public function set selectedItem(value:Object):void {
			_selectedItem = value;
		}
	}
}