/**
 * Copyright (c) 2011 Tuomas Artman, http://artman.fi
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.flow.containers {

	import com.flow.collections.DisplayObjectCollection;
	import com.flow.collections.IList;
	import com.flow.components.Component;
	import com.flow.containers.layout.AbsoluteLayout;
	import com.flow.containers.layout.LayoutBase;
	import com.flow.events.CollectionEvent;
	import com.flow.events.CollectionEventKind;
	import com.flow.events.InvalidationEvent;
	import com.flow.events.StateEvent;
	import com.flow.managers.LayoutManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	[DefaultProperty("children")]
	[Event(name="creationComplete", type="com.flow.events.ComponentEvent")]
	[Event(name="invalidateLayout", type="com.flow.events.InvalidationEvent")]
	public class Container extends Component {
		
		private var _children:DisplayObjectCollection;
		private var childrenInvalidated:Boolean = false;
		private var _layout:LayoutBase;

		public function Container() {
			super();
			children = new DisplayObjectCollection();
			layout = getDefaultLayout();
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		protected function getDefaultLayout():LayoutBase {
			return new AbsoluteLayout();
		}
		
		private function added(e:Event):void {
			depth = 0;
			var p:DisplayObject = parent;
			while(p) {
				depth++;
				p = p.parent;
			}
			invalidate();
		}
		
		override public function invalidate(e:Event = null):void {
			super.invalidate();
			invalidateLayout();
		}

		[ElementType("DisplayObject")]
		public function get children():IList {
			return _children;
		}
		public function set children( value:* ):void {
			if ( _children != value ) {
				if(_children) {
					_children.removeEventListener(CollectionEvent.COLLECTION_CHANGE, invalidateChildren);
				}
				
				var parsed:DisplayObjectCollection = null;
				if (value is DisplayObjectCollection) {
					parsed = value;
				} else if(value is Vector.<DisplayObject>) {
					parsed = new DisplayObjectCollection(value);
				} else if(value is Array) {
					var vec:Vector.<DisplayObject> = new Vector.<DisplayObject>();
					for(var i:int = 0; i<value.length; i++) {
						vec.push(value[i]);
					}
					parsed = new DisplayObjectCollection(vec);
				} else if(value is DisplayObject) {
					vec = new Vector.<DisplayObject>();
					vec.push(value);
					parsed = new DisplayObjectCollection(vec);
				} else if(value === null) {
					parsed = new DisplayObjectCollection();
				}

				if(_children) {
					for(i = 0; i<_children.length; i++) {
						_children.getItemAt(i).removeEventListener(StateEvent.ACTIVITY_CHANGE, invalidateChildren);
					}
				}
				_children = parsed;
				
				if(_children) {
					_children.addEventListener(CollectionEvent.COLLECTION_CHANGE, childrenModified, false, 0, true);
					for(i = 0; i<_children.length; i++) {
						if(_children.getItemAt(i) is Component) {
							_children.getItemAt(i).addEventListener(StateEvent.ACTIVITY_CHANGE, invalidateChildren, false, 0, true);
						}
					}
				}
				invalidateChildren();
			}
		}
		
		public function childrenModified(e:CollectionEvent):void {
			for(var i:int = 0; i<e.items.length; i++) {
				if(e.items[i] is Component) {
					if(e.kind == CollectionEventKind.ADD) {
						(e.items[i] as Component).addEventListener(StateEvent.ACTIVITY_CHANGE, invalidateChildren, false, 0, true);
					}
					if(e.kind == CollectionEventKind.REMOVE) {
						(e.items[i] as Component).removeEventListener(StateEvent.ACTIVITY_CHANGE, invalidateChildren);
					}
				}
			}
			invalidateChildren();
		}
		
		public function invalidateChildren(e:Event = null):void {
			//trace("INVALIDATE " + this);
			if(!childrenInvalidated) {
				childrenInvalidated = true;
				if(manager.layoutPhase != LayoutManager.LAYOUT_PHASE_VALIDATING) {
					manager.invalidateChildren(this);
					invalidateLayout();
				} else {
					validateChildren();
					layoutInvalidated = true;
					validateLayout();
				}
			}
		}
		
		public function get layout():LayoutBase {
			return _layout;
		}
		public function set layout(value:LayoutBase):void {
			if(value != _layout) {
				if(_layout) {
					_layout.resignFromComponent(this); 
				}
				_layout = value;
				_layout.assignToComponent(this);
			}
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			if(child) {
				removeChild(child);
				_children.addItem(child);
			}
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			if(child) {
				removeChild(child);
				_children.addItemAt(child, index);
			}
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			if(_children.getItemIndex(child) != -1) {
				_children.removeItemAt(_children.getItemIndex(child));
			}
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject {
			return removeChild(_children.getItemAt(index) as DisplayObject);
		}
		
		protected function rawAddChild(child:DisplayObject):DisplayObject {
			return super.addChild(child);
		}
		
		protected function rawAddChildAt(child:DisplayObject, index:int):DisplayObject {
			return super.addChildAt(child, index);
		}
		
		protected function rawRemoveChild(child:DisplayObject):DisplayObject {
	
			return super.removeChild(child);
		}
		
		protected function rawRemoveChildAt(index:int):DisplayObject {
			return super.removeChildAt(index);
		}

		override public function invalidateTree():void {
			super.invalidateTree();
			for(var i:int=0; i<numChildren; i++) {
				var comp:Component = getChildAt(i) as Component;
				if(comp) {
					comp.invalidateTree();
				}
			}
		}
		
		override public function invalidateLayout(fromChild:Boolean = false):void {
			if(!layoutInvalidated && parent) {
				layoutInvalidated = true;
				dispatchEvent(new InvalidationEvent(InvalidationEvent.INVALIDATE_LAYOUT));
				if(manager.layoutPhase != LayoutManager.LAYOUT_PHASE_VALIDATING) {
					var delegate:Boolean = true;
					if(!(parent is Container)) {
						delegate = false;
					} else if(fromChild == true && hasExplicitWidth && hasExplicitHeight) {
						if(_right.isNull && _bottom.isNull) {
							delegate = false;
						}
					}
					if(delegate) { 
						(parent as Container).invalidateLayout(true);
					} else {
						manager.invalidateLayout(this);
					}
				} else {
					manager.invalidateLayout(this);
				}
			}
		}
		
		public function validateLayoutOnRoot(e:Event = null):void {
			var t:Number = getTimer();
			measureChildren();
			validateLayout();
		}

		public function validateLayout(e:Event = null):void {
			layoutInvalidated = false;
			if(layout) {
				layout.layout(width, height);
				for(var i:int=0; i<numChildren; i++) {
					var displayObject:DisplayObject = getChildAt(i);
					if(displayObject is Container) {
						(displayObject as Container).validateLayout();
					}
				}
			}
		}
		
		public function validateNow():void {
			invalidateLayout();
			validateChildren();
			validateLayout();
			validate();
		}
		
		public function validateChildren():void {
			if (childrenInvalidated) {
				childrenInvalidated = false;
				var sanitizedChildren:Vector.<DisplayObject> = _children.source.concat();
				for(var i:int = sanitizedChildren.length-1; i>=0; i--) {
					if(sanitizedChildren[i] is Component && !(sanitizedChildren[i] as Component).includeAsChild) {
						sanitizedChildren.splice(i, 1);
					} else if(sanitizedChildren[i] is Component) {
						sanitizedChildren[i] = (sanitizedChildren[i] as Component).visualRepresentation;
					}
				}
				for(i = numChildren-1; i>=0; i--) {
					if(sanitizedChildren.indexOf(getChildAt(i)) == -1) {
						rawRemoveChild(getChildAt(i));
					}
				}
				for(i = 0; i<sanitizedChildren.length; i++) {
					if(sanitizedChildren[i].parent != this) {
						rawAddChild(sanitizedChildren[i]);
					}
					setChildIndex(sanitizedChildren[i],i);
				}			
				if(layout) {
					layout.childrenChanged();
				}
			}
		}
		
		public function measureChildren():void {
			for(var i:int=0; i<numChildren; i++) {
				var comp:Component = getChildAt(i) as Component;
				if(comp) {
					if(comp.propertiesInvalidated) {
						comp.validateProperties();
						comp.propertiesInvalidated = false;
					}
					if(comp is Container) {
						(comp as Container).measureChildren();
					} else {
						comp.measure();
					}
				}
			}
			measure();
		}
		
		override public function measure():void {
			if(_layout) {
				_layout.measure();
			}
		}
	}
}