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
	import com.flow.components.HScrollBar;
	import com.flow.containers.layout.AbsoluteLayout;
	import com.flow.containers.layout.LayoutBase;
	import com.flow.events.CollectionEvent;
	import com.flow.events.CollectionEventKind;
	import com.flow.events.InvalidationEvent;
	import com.flow.events.StateEvent;
	import com.flow.managers.LayoutManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * The Container class is the base grouping class for visual elements. The Container takes as children any 
	 * components, containers or flash display objects. Use this container when you want to manage visual children.
	 */	
	[DefaultProperty("children")]
	[Event(name="creationComplete", type="com.flow.events.ComponentEvent")]
	[Event(name="invalidateLayout", type="com.flow.events.InvalidationEvent")]
	public class Container extends Component {
		
		/** @private */ 
		protected var _children:DisplayObjectCollection;
		/** @private */ 
		protected var childrenInvalidated:Boolean = false;
		/** @private */ 
		protected var _layout:LayoutBase;
		
		public var childContainer:DisplayObjectContainer;

		public function Container() {
			super();
			childContainer = this;
			_layout = getDefaultLayout();
			_layout.assignToComponent(this);
			children = new DisplayObjectCollection();
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		/**
		 * Returns a default layout instance to use if the user hasn't defined any. Subclasses might override this method
		 * to return a layout more appropriate for their needs. The container's implementation returns a absolute layout.
		 * @return A layout instance
		 */		
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
		
		/** @inheritDoc */
		override public function invalidate(e:Event = null):void {
			super.invalidate();
			invalidateLayout();
		}
		
		/**
		 * The visual content children for this Group.
		 * This method is used internally by Flow and is not intended for direct use by developers. 
		 */		
		[ArrayElementType("DisplayObject")]
		public function get children():* {
			return _children;
		}
		public function set children(value:*):void {
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
		
		private function childrenModified(e:CollectionEvent):void {
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
		
		private function invalidateChildren(e:Event = null):void {
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
		
		/** The layout instance used by the container to lay out it's children. */		
		public function get layout():LayoutBase {
			return _layout;
		}
		public function set layout(value:LayoutBase):void {
			if(value != _layout) {
				if(!value) {
					throw new Error("Container requires a layout");
				}
				if(_layout) {
					_layout.resignFromComponent(this); 
				}
				_layout = value;
				_layout.assignToComponent(this);
			}
		}
		
		/** @inheritDoc */	
		override public function addChild(child:DisplayObject):DisplayObject {
			if(child) {
				removeChild(child);
				_children.addItem(child);
			}
			return child;
		}
		
		/** @inheritDoc */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			if(child) {
				removeChild(child);
				_children.addItemAt(child, index);
			}
			return child;
		}
		
		/** @inheritDoc */
		override public function removeChild(child:DisplayObject):DisplayObject {
			if(_children.getItemIndex(child) != -1) {
				_children.removeItemAt(_children.getItemIndex(child));
			}
			return child;
		}
		
		/** @inheritDoc */
		override public function removeChildAt(index:int):DisplayObject {
			return removeChild(_children.getItemAt(index) as DisplayObject);
		}
		
		/** @private */
		protected function rawAddChild(child:DisplayObject):DisplayObject {
			return super.addChild(child);
		}
		
		/** @private */
		protected function rawAddChildAt(child:DisplayObject, index:int):DisplayObject {
			return super.addChildAt(child, index);
		}
		
		/** @private */
		protected function rawRemoveChild(child:DisplayObject):DisplayObject {
			return super.removeChild(child);
		}
		
		/** @private */
		protected function rawRemoveChildAt(index:int):DisplayObject {
			return super.removeChildAt(index);
		}
		
		/** @private */
		override public function invalidateTree():void {
			super.invalidateTree();
			for(var i:int=0; i<numChildren; i++) {
				var comp:Component = getChildAt(i) as Component;
				if(comp) {
					comp.invalidateTree();
				}
			}
		}
		
		/**
		 * Call invalidateLayout when a property that might affect the size of your component has been changed. This will make flow
		 * validate the size of your component during the next rendering cycle. It's not necessary to call invalidate() at the same time,
		 * as Flow will issue a validation if the component's size is actually changed during measurement.
		 *  
		 * @param fromChild Defines whether the invalidation has been called from a child component. When you call it, it should be left as
		 * false.
		 */	
		override public function invalidateLayout(fromChild:Boolean = false):void {
			if(!layoutInvalidated && parent) {
				layoutInvalidated = true;
				dispatchEvent(new InvalidationEvent(InvalidationEvent.INVALIDATE_LAYOUT));
				if(manager.layoutPhase != LayoutManager.LAYOUT_PHASE_VALIDATING) {
					var delegate:Boolean = true;
					if(!(parentContainer)) {
						delegate = false;
					} else if(fromChild == true && hasExplicitWidth && hasExplicitHeight) {
						if(_right.isNull && _bottom.isNull) {
							delegate = false;
						}
					}
					if(delegate) { 
						parentContainer.invalidateLayout(true);
					} else {
						manager.invalidateLayout(this);
					}
				} else {
					manager.invalidateLayout(this);
				}
			}
		}
		
		/** @private */
		public function validateLayoutOnRoot(e:Event = null):void {
			var t:Number = getTimer();
			measureChildren();
			validateLayout();
		}
		
		/** @private */
		public function validateLayout(e:Event = null):void {
			layoutInvalidated = false;
			_layout.layout(width, height);
			for(var i:int=0; i<childContainer.numChildren; i++) {
				var displayObject:DisplayObject = childContainer.getChildAt(i);
				if(displayObject is Container) {
					(displayObject as Container).validateLayout();
				}
			}
		}
		
		/**
		 * Sometimes you may need to validate a containers children, layout and rendering before the next rendering
		 * cycle takes place, e.g. measuredWidht might not hold a correct value before it has been validated. 
		 * validateNow() will validate the container and it's children instantly.
		 */		
		public function validateNow():void {
			invalidateLayout();
			validateChildren();
			validateLayout();
			validate();
		}
		
		/** @private */
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
				for(i = childContainer.numChildren-1; i>=0; i--) {
					if(sanitizedChildren.indexOf(getChildAt(i)) == -1) {
						if(childContainer is Container) {
							var child:DisplayObject = (childContainer as Container).rawRemoveChildAt(i);
						} else {
							child = childContainer.removeChildAt(i);
						}
						if(child is Component) {
							(child as Component).parentContainer = null;
						}
					}
				}
				for(i = 0; i<sanitizedChildren.length; i++) {
					if(sanitizedChildren[i].parent != this) {
						if(childContainer is Container) {
							child = (childContainer as Container).rawAddChild(sanitizedChildren[i])
						} else {
							child = childContainer.addChild(sanitizedChildren[i])
						}
						if(child is Component) {
							(child as Component).parentContainer = this;
						}
					}
					childContainer.setChildIndex(sanitizedChildren[i],i);
				}			
				_layout.childrenChanged();
			}
		}
		
		/** @private */
		public function measureChildren():void {
			for(var i:int=0; i<childContainer.numChildren; i++) {
				var comp:Component = childContainer.getChildAt(i) as Component;
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
		
		/**
		 * Measure works differently on an container than on an component, as usually the layout instance takes care
		 * of measuring it's content, so normally you don't need to override this method when using a container as a
		 * subclass.
		 */		
		override public function measure():void {
			_layout.measure();
		}
		
		/** The padding of the container's content */
		public function get padding():Number {
			return _layout.padding;
		}
		public function set padding(value:Number):void {
			_layout.padding = value;
		}
		
		/** The vertical padding of the container's content */
		public function get verticalPadding():Number {
			return _layout.verticalPadding;
		}
		public function set verticalPadding(value:Number):void {
			_layout.verticalPadding = value;
		}
		
		/** The horizontal padding of the container's content */
		public function get horizontalPadding():Number {
			return _layout.horizontalPadding;
		}
		public function set horizontalPadding(value:Number):void {
			_layout.horizontalPadding = value;
		}
		
		/** The top padding of the container's children */		
		public function get paddingTop():Number {
			return _layout.paddingTop;
		}
		public function set paddingTop(value:Number):void {
			_layout.paddingTop = value;
		}
		
		/** The right-side padding of the container's children */		
		public function get paddingRight():Number {
			return _layout.paddingRight;
		}
		public function set paddingRight(value:Number):void {
			_layout.paddingRight = value;
		}
		
		/** The bottom padding of the container's children */		
		public function get paddingBottom():Number {
			return _layout.paddingBottom;
		}
		public function set paddingBottom(value:Number):void {
			_layout.paddingBottom = value;
		}
		
		/** The left-side padding of the container's children */		
		public function get paddingLeft():Number {
			return _layout.paddingLeft;
		}
		public function set paddingLeft(value:Number):void {
			_layout.paddingLeft = value;
		}
	}
}