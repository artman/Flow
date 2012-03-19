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

package com.flow.components {
	
	import com.flow.components.measuring.MeasureUnit;
	import com.flow.components.measuring.MeasureUnits;
	import com.flow.containers.Container;
	import com.flow.effects.Effect;
	import com.flow.effects.transitions.FadeTransition;
	import com.flow.events.ComponentEvent;
	import com.flow.events.InvalidationEvent;
	import com.flow.events.StateEvent;
	import com.flow.graphics.fills.IFill;
	import com.flow.graphics.strokes.IStroke;
	import com.flow.managers.LayoutManager;
	import com.flow.managers.ResourceManager;
	import com.flow.managers.TooltipManager;
	import com.flow.motion.IAnimateable;
	
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.IFactory;
	import mx.core.IStateClient2;
	import mx.states.State;
	
	/**
	 * Dispatched when the state of the component changes.
	 */	
	[Event(name="stateChange", type="com.flow.events.StateEvent")]

	/**
	 * Component is the base class for displayable objects. It provides properties for constrained-based layout, states support
	 * and a robust validation scheme. Components are used throughout the Flow framework and most displayable classes subclass
	 * from Component.
	 * 
	 * In a Flex-application UIComponent would be the equivalent to Compoent in Flow. 
	 */	
	[DefaultProperty("fill")]
	public class Component extends Sprite implements IStateClient2, IFactory, IAnimateable {
		
		public static const STATE_UP:String = "up";
		public static const STATE_OVER:String = "over";
		public static const STATE_DOWN:String = "down";
		public static const STATE_FOCUS:String = "focus";
		public static const STATE_DISABLED:String = "disabled";
	
		/** A static reference to the LayoutManager. */
		public static var manager:LayoutManager;
		
		/** A static reference to the ResourceManager. */
		[Bindable]
		public static var resources:ResourceManager = ResourceManager.instance;
		
		
		/** @private */ 
		protected var _x:Number = 0;
		/** @private */ 
		protected var _y:Number = 0;
		/** @private */ 
		protected var _top:MeasureUnit;
		/** @private */ 
		protected var _bottom:MeasureUnit;
		/** @private */ 
		protected var _left:MeasureUnit;
		/** @private */ 
		protected var _right:MeasureUnit;		
		/** @private */ 
		protected var _verticalCenter:MeasureUnit;
		/** @private */ 
		protected var _horizontalCenter:MeasureUnit;
		/** @private */ 
		protected var _w:MeasureUnit;
		/** @private */ 
		protected var _h:MeasureUnit;
		
		/** @private */ 
		protected var _measuredWidth:Number = 0;
		/** @private */ 
		protected var _minWidth:Number;
		/** @private */ 
		protected var _maxWidth:Number;
		/** @private */ 
		protected var _absoluteWidth:Number;
		/** Whether the component has been assigned a implicit width. */
		public var hasExplicitWidth:Boolean = false;		

		/** @private */
		protected var _measuredHeight:Number = 0;
		/** @private */
		protected var _minHeight:Number;
		/** @private */
		protected var _maxHeight:Number;
		/** @private */ 
		protected var _absoluteHeight:Number;
		/** Whether the component has been assigned a implicit height. */
		public var hasExplicitHeight:Boolean = false;
		
		/** @private */
		public var includeIn:String;
		private var _measureUnits:MeasureUnits;
		private var _borderExpand:int = 0;
		private var _clip:Boolean = false;
		private var _visible:Boolean = true;
		/** @private */ 
		protected var _active:Boolean = true;
		/** @private */ 
		protected var _transition:FadeTransition;
		/** @private */ 
		protected var _fill:IFill;
		/** @private */ 
		protected var _stroke:IStroke;
		
		private var _states:Array;
		private var _currentState:String = "";
		/** @private */ 
		protected var statesActive:Vector.<State>;
		private var _disabled:Boolean = false;
		private var _interactive:Boolean = false;
		/** @private */ 
		public var focusable:Boolean = false;
		
		private var _tooltip:String;
		private var _tabIndex:int = -1;
		/** @private */ 
		protected var _focusElement:InteractiveObject;
		
		private var pressed:Boolean = false;
		/** @private */ 
		public var stateMovieClips:Vector.<MovieClip>;
		
		/** @private */
		public var propertiesInvalidated:Boolean = false;
		/** @private */
		public var layoutInvalidated:Boolean = false;
		/** @private */
		public var invalidated:Boolean = false;
		
		/** The depth of the component inside the displayList. */
		public var depth:int = 0;
		
		/** The parent container if the component has been added as a child of a container. */
		public var parentContainer:Container;
		
		/** @private */ 
		protected var _snapToPixels:Boolean = true;
		/** 
		 * If set to true, forces the component to snap to an even width. You might want to do this on containers who's widths are changing
		 * and that has horizontally centered content. */
		public var snapToEventWidth:Boolean = false;
		/** If set to true, forces the component to snap to an even height. You might want to set this to true on containers who's heights are
		 *  changing and who have vertically centered content. */
		public var snapToEventHeight:Boolean = false;
		
		/** The data that is assigned to the component if it's used as a item renderer. */
		[Bindable] public var data:*;
		/** The index of the component in a list if the component is used as a item renderer. */
		[Bindable] public var rendererIndex:int;
		
		private var _effect:Effect;
		
		private var addedStatesBeforeInit:Array;
		
		[Event(name="creationComplete", type="com.flow.events.ComponentEvent")]
		public function Component() {
			super();
			_states = [];
			addedStatesBeforeInit = [];
			statesActive = new Vector.<State>();
			_top = new MeasureUnit(null);
			_bottom = new MeasureUnit(null);
			_left = new MeasureUnit(null);
			_right = new MeasureUnit(null);
			_w = new MeasureUnit(null);
			_h = new MeasureUnit(null);
			_verticalCenter = new MeasureUnit(null);
			_horizontalCenter = new MeasureUnit(null);
			manager.invalidateInit(this);
			invalidateProperties();
			focusRect = null;
			preInitialize();
			tabEnabled = false;
		}

		/** @private */		
		public final function init():void {
			initialize();
			dispatchEvent(new ComponentEvent(ComponentEvent.CREATION_COMPLETE));
		}
		
		/**
		 * Sets whether the component automatically tries to assign itself states based on user interaction.
		 * The states that are assigned (if supported by the subclass) are up, over, down, focused and disabled. 
		 * @return Whether the component is interactive.
		 */	
		public function get interactive():Boolean {
			return _interactive
		}
		public function set interactive(value:Boolean):void {
			if(value != _interactive) {
				_interactive = value;
				if(_interactive) {
					addEventListener(MouseEvent.ROLL_OVER, mouseOver);
					addEventListener(MouseEvent.ROLL_OUT, mouseOut);
					addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					addEventListener(MouseEvent.MOUSE_UP, mouseUp);
					addEventListener(FocusEvent.FOCUS_IN, focusIn);
					addEventListener(FocusEvent.FOCUS_OUT, focusOut);
				} else {
					removeEventListener(MouseEvent.ROLL_OVER, mouseOver);
					removeEventListener(MouseEvent.ROLL_OUT, mouseOut);
					removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
					removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
					removeEventListener(FocusEvent.FOCUS_IN, focusIn);
					removeEventListener(FocusEvent.FOCUS_OUT, focusOut);
				}
				tabEnabled = tabChildren = useHandCursor = buttonMode = _interactive;
			}
		}
		
		/**
		 * Override this method to initalize any properties at the beginning of the component lifecycle. This method is called
		 * during execution of the constructor.
		 */		
		protected function preInitialize():void {
			// Override
		}
		
		/**
		 * Override this method to initialize any properties before the first rendering cycle of the component. At this stage all
		 * properties have been assigned correct values, and any children have been created.
		 */		
		protected function initialize():void {
			// Override
		}
		
		/**
		 * Call invalidateProperties to issue a call to validateProperties during the next rendering cycle. It's more efficient to
		 * defer validation of any properties that might take some time to complete to the next rendering cycle, as a property
		 * might be changed a number of times before rendering occurs.
		 * @param layoutValidationRequired Pass in true if you suspect that validating your properties also affect the size of your
		 * component. In this case, invalidateLayout() will be called automatically.
		 * 
		 */		
		public function invalidateProperties(layoutValidationRequired:Boolean = true):void {
			propertiesInvalidated = true;
			if(layoutValidationRequired) {
				invalidateLayout();
			}
			invalidate();
		}
		
		/**
		 * Call invalidate to force a re-rendering of the component, but not change it's size. All components that have been
		 * invalidated will receive a draw-call during the next rendering cycle. You should not directly position any child
		 * objects or draw any graphics directly when component properties are validate. Instead, use invalidate to defer rendering
		 * of your component to the next rendering cycle.
		 */		
		public function invalidate(e:Event = null):void {
			if(!invalidated) {
				invalidated = true;	
				manager.invalidateComponent(this);
			}
		}
		
		/** @private */
		public function invalidateTree():void {
			invalidateLayout();
		}
		
		/**
		 * Call invalidateLayout when a property that might affect the size of your component has been changed. This will make flow
		 * validate the size of your component during the next rendering cycle. It's not necessary to call invalidate() at the same time,
		 * as Flow will issue a validation if the component's size is actually changed during measurement.
		 *  
		 * @param fromChild Defines whether the invalidation has been called from a child component. Setting this has no effect
		 * on a component, as it's implemented by the Container.
		 */		
		public function invalidateLayout(fromChild:Boolean = false):void {
			if(parentContainer) {
				parentContainer.invalidateLayout();
			}
		}
		
		/** @private */
		public function validate():void {
			if(_visible) {
				if(propertiesInvalidated) {
					validateProperties();
					measure();
					propertiesInvalidated = false;
				}
				
				if(checkVisibility()) {
					if(!super.visible) {
						super.visible = true;
					}
					var w:Number = sanitizeWidth(!isNaN(_absoluteWidth) ? _absoluteWidth : _measuredWidth);
					var h:Number = sanitizeHeight(!isNaN(_absoluteHeight) ? _absoluteHeight : _measuredHeight);
					draw(w, h);
				} else {
					if(super.visible) {
						super.visible = false;
					}
				}
			}
			invalidated = false;
		}
		
		/**
		 * Checks whether the component is visible. You normally would not override this method in a subclass, but there
		 * might be instanced where it's needed. The implementation returns true if the component has a width and height
		 * that are not 0.
		 * @return Whether the component is visible and should be rendered.
		 */		
		protected function checkVisibility():Boolean {
			var w:int = sanitizeWidth(!isNaN(_absoluteWidth) ? _absoluteWidth : _measuredWidth);
			var h:int = sanitizeHeight(!isNaN(_absoluteHeight) ? _absoluteHeight : _measuredHeight);
			if(w>0 && h>0) {
				return true
			}
			return false;
		}
		
		/** @inheritDoc */		
		override public function get visible():Boolean {
			return _visible;
		}
		override public function set visible(value:Boolean):void {
			if(value != _visible) {
				_visible = value;
				if(value) {
					invalidateLayout();
					super.visible = true;
				} else {
					super.visible = false;
				}
			}
		}
		
		/**
		 * This method is called whenever the component needs to be measured. Sub-classes should implement this to ensure
		 * that the component can be used without explicitly setting it's width and height.
		 * 
		 * Implementations should measure the minimum width and height that the component requires to fully draw itself
		 * (e.g. depending on the text in a Label). The method does not return anything. Instead, for a full implementation,
		 * set the measuredWidth and measuredHeight properties of the component according to your measurement results.
		 */		
		public function measure():void {
			// Override	
		}
		
		/**
		 * Draw is called whenever the component needs to render itself. Override this method to lay out any children and render
		 * into the component's graphics context. Note that the component implementation clears the graphics context and renders
		 * in any fills or strokes defined by the user.
		 * 
		 * @param width The absolute, non-scaled width of the component.
		 * @param height The absolute, non-scaled height of the component.
		 */		
		public function draw(width:Number, height:Number):void {
			graphics.clear();
			if(_fill) {
				_fill.beginDraw(graphics, width, height);
			}
			if(_stroke) {
				_stroke.beginDraw(graphics, width, height);
			}
			if(_fill || _stroke) {
				var widthExt:int = 0;
				if(_borderExpand) {
					widthExt = _borderExpand * 2 - 1;
				}
				graphics.drawRect(-borderExpand,-borderExpand, width + widthExt, height + widthExt);
			}
			if(_fill) {
				_fill.endDraw(graphics);
			}
			applyMask(width, height);
		}
		
		/**
		 * Applies a mask after rendering the component. Override this to implement your own masking or scrolling behaviour. The default implementation
		 * will apply a mask to the full area of the component if it's clip-property is set to true.
		 * @param width The absolute, non-scaled width of the component.
		 * @param height The absolute, non-scaled height of the component.
		 */		
		protected function applyMask(width:Number, height:Number):void {
			if(clip) {
				var inset:int = 0;
				if(_stroke) {
					inset = Math.ceil(_stroke.thickness/2);
				}
				scrollRect = new Rectangle(0, 0, snapToPixels ? Math.round(width) : width + inset, snapToPixels ? Math.round(height) : height + inset);
			}
		}
		
		
		/*---------------- Measure --------------------*/
		/** @private */
		public function sanitizeWidth(value:Number):Number {
			return (isNaN(_minWidth) || value > _minWidth) ? ((isNaN(_maxWidth) || value < _maxWidth) ? value : _maxWidth) : _minWidth;
		}
		
		/** @private */
		public function sanitizeHeight(value:Number):Number {
			return (isNaN(_minHeight) || value > _minHeight) ? ((isNaN(_maxHeight) || value < _maxHeight) ? value : _maxHeight) : _minHeight;
		}
		
		/** The vertical distance in pixels or percent from the top edge of the component to the parent's top edge. */
		[Bindable] [Animateable]
		public function get top():* {
			return _top.unit;
		}
		public function set top(value:*):void {
			_top.parse(value);
			if(value) {
				verticalCenter = null;
			}
			invalidateLayout();
		}
		
		/** The vertical distance in pixels or percent from the bottom edge of the component to the parent's bottom edge. */
		[Bindable] [Animateable]
		public function get bottom():* {
			return _bottom.unit;
		}
		public function set bottom(value:*):void {
			_bottom.parse(value);
			if(value) {
				verticalCenter = null;
			}
			invalidateLayout();
		}
		
		/** The horizontal distance in pixels or percent from the left edge of the component to the parent's left edge. */
		[Bindable] [Animateable]
		public function get left():* {
			return _left.unit;
		}
		public function set left(value:*):void {
			_left.parse(value);
			if(value) {
				horizontalCenter = null;
			}
			invalidateLayout();
		}
		
		/** The horizontal distance in pixels or percent from the right edge of the component to the parent's right edge. */
		[Bindable] [Animateable]
		public function get right():* {
			return _right.unit;
		}
		public function set right(value:*):void {
			_right.parse(value);
			if(value) {
				horizontalCenter = null;
			}
			invalidateLayout();
		}
		
		/** The width of the component in pixels. If you use MXML, you can also set the width to a percentage of the parent's width. */
		[Bindable(event="widthChange")] [PercentProxy("percentWidth")]
		override public function get width():Number {
			if(!_w.isNull && !_w.isPercentage) {
				return sanitizeWidth(_w.unit);
			}
			return sanitizeWidth(absoluteWidth ? absoluteWidth : measuredWidth ? measuredWidth : 0);
		}
		override public function set width(value:Number):void {
			value = snapToPixels ? Math.round(value): value;
			value = snapToEventWidth ? Math.round(value/2)*2 : value;
			
			if(value != width) {
				invalidateLayout();
			}
			_w.parse(value);
			if(!_w.isNull && !_w.isPercentage) {
				absoluteWidth = _w.value;
				if(isNaN(_absoluteWidth)) {
					_absoluteWidth = value;
				}
				hasExplicitWidth = true;
			} else {
				hasExplicitHeight = false;
			}
		}
		
		/** The width of the component in percent of the parent's width. */
		public function get percentWidth():Number {
			if(_w.isPercentage) {
				return _w.value;
			}
			return undefined;
		}
		public function set percentWidth(value:Number):void {
			_w.parse(value + "%");
			invalidateLayout();
		}
		
		/** The height of the component in pixels. If you use MXML, you can also set the height to a percentage of the parent's height. */
		[Bindable(event="heightChange")] [PercentProxy("percentHeight")]
		override public function get height():Number {
			if(!_h.isNull && !_h.isPercentage) {
				return sanitizeHeight(_h.unit);
			}
			return sanitizeHeight(absoluteHeight ? absoluteHeight : measuredHeight ? measuredHeight : 0);
		}
		override public function set height(value:Number):void {
			value = snapToPixels ? Math.round(value): value;
			value = snapToEventHeight ? Math.round(value/2)*2 : value;
			if(value != height) {
				invalidateLayout();
			}
			_h.parse(value);
			if(!_h.isNull && !_h.isPercentage) {
				absoluteHeight = value;
				if(isNaN(_absoluteHeight)) {
					_absoluteHeight = value;
				}
				hasExplicitHeight = true;
			} else {
				hasExplicitHeight = false;
			}
		}
		/** The height of the component in percent of the parent's height. */
		public function get percentHeight():Number {
			if(_h.isPercentage) {
				return _h.value;
			}
			return undefined;
		}
		public function set percentHeight(value:Number):void {
			_h.parse(value + "%");
			invalidateLayout();
		}
		
		/** The minimum width of the component. The component won't be rendered smaller than this. */
		[Bindable]
		public function get minWidth():Number {
			return _minWidth;
		}
		public function set minWidth(value:Number):void {
			_minWidth = value;
			invalidateLayout();
		}
		
		/** The minimum height of the component. The component won't be rendered smaller than this. */
		[Bindable]
		public function get minHeight():Number {
			return _minHeight;
		}
		public function set minHeight(value:Number):void {
			_minHeight = value;
			invalidateLayout();
		}
		
		/** The maximum width of the component. The component won't be rendered larger than this */
		public function get maxWidth():Number {
			return _maxWidth;
		}
		public function set maxWidth(value:Number):void {
			if(value != _maxWidth) {
				_maxWidth = value;
				invalidateLayout();
			}
		}
		
		/** The maximum height of the component. The component won't be rendered larger than this */
		public function get maxHeight():Number {
			return _maxHeight;
		}
		public function set maxHeight(value:Number):void {
			if(value != _maxHeight) {
				_maxHeight = value;
				invalidateLayout();
			}
		}
		
		/** The measured width of the component. This needs to be set during a call to measure(). */
		[Bindable]
		public function get measuredWidth():Number {
			return _measuredWidth;
		}
		public function set measuredWidth(value:Number):void {
			var oldWidth:int = width;
			_measuredWidth = value;
			if(width != oldWidth) {
				invalidate();
				if(hasEventListener("widthChange")) {
					dispatchEvent(new Event("widthChange"));
				}
			}
		}
		
		/** The measured height of the component. This needs to be set during a call to measure(). */
		[Bindable]
		public function get measuredHeight():Number {
			return _measuredHeight;
		}
		public function set measuredHeight(value:Number):void {
			var oldHeight:int = height;
			_measuredHeight = value;
			if(height != oldHeight) {
				invalidate();
				if(hasEventListener("heightChange")) {
					dispatchEvent(new Event("heightChange"));
				}
			}
		}
		
		/** The vertical distance in pixels or percent from the center of the component to the center of the parent's content area. */
		[Bindable]
		public function get verticalCenter():* {
			return _verticalCenter.unit;
		}
		public function set verticalCenter(value:*):void {
			_verticalCenter.parse(value);
			if(value) {
				left = null;
				right = null;
			}
			invalidateLayout();
		}
		
		/** The horizontal distance in pixels or percent from the center of the component to the center of the parent's content area. */
		[Bindable]
		public function get horizontalCenter():* {
			return _horizontalCenter.unit;
		}
		public function set horizontalCenter(value:*):void {
			_horizontalCenter.parse(value);
			if(value) {
				left = null;
				right = null;
			}
			invalidateLayout();
		}
		
		/** @private */
		public function get absoluteWidth():Number {
			return _absoluteWidth;
		}
		/**  @private */
		public function set absoluteWidth(value:Number):void {
			if(_absoluteWidth != value) {
				_absoluteWidth = value;
				invalidate();
				if(hasEventListener("widthChange")) {
					dispatchEvent(new Event("widthChange"));
				}
			}
		}
		
		/** @private */
		public function get absoluteHeight():Number {
			return _absoluteHeight;
		}
		/**  @private */
		public function set absoluteHeight(value:Number):void {
			if(_absoluteHeight != value) {
				_absoluteHeight = value;
				invalidate();
				if(hasEventListener("heightChange")) {
					dispatchEvent(new Event("heightChange"));
				}
			}
		}
		
		/** @inheritDoc */
		[Bindable]
		override public function get x():Number {
			return _x;
		}
		override public function set x(value:Number):void {
			if(value != _x) {
				_x = value;
				super.x = _snapToPixels ? Math.round(value) : value;
			}
		}
		
		/** @inheritDoc */
		[Bindable]
		override public function get y ():Number {
			return _y;
		}
		override public function set y (value:Number):void {
			if(value != _y) {
				_y = value;
				super.y = _snapToPixels ? Math.round(value) : value;
			}
		}
		
		/** Whether to snap the position and dimensions to full pixels (default true). */
		public function get snapToPixels():Boolean {
			return _snapToPixels;
		}
		public function set snapToPixels(value:Boolean):void {
			if(value != _snapToPixels) {
				_snapToPixels = value;
				x = (--_x) + 1; // force update
				y = (--_y) + 1;
			}
		}
		
		/** @private */
		public function get measureUnits():MeasureUnits {
			if(!_measureUnits) {
				_measureUnits = new MeasureUnits();
				_measureUnits.top = _top;
				_measureUnits.bottom = _bottom;
				_measureUnits.left = _left;
				_measureUnits.right = _right;
				_measureUnits.w = _w;
				_measureUnits.h = _h;
				_measureUnits.verticalCenter = _verticalCenter;
				_measureUnits.horizontalCenter = _horizontalCenter;
			}
			return _measureUnits;
		}
		
		/**
		 * Traverses up the display list and fetches the width for the first component that has a explicit width .
		 * Returns -1 if none had an explicit width.
		 */		
		public function get firstExplicitWidth():int {
			if(hasExplicitWidth) {
				return width;
			}
			var component:Component = this;
			while(component.parentContainer) {
				component = component.parentContainer;
				if(component.hasExplicitWidth) {
					return component.width;
				}
			}
			return -1
		}
		
		/** 
		 * The fill of the component. If assigned, the fill is applied to the full width and height of the component
		 * during rendering.
		 */
		[AnimateableChild]
		public function get fill():IFill {
			return _fill;
		}
		public function set fill(value:IFill):void {
			if(_fill != value) {
				if(_fill) {
					_fill.removeEventListener(InvalidationEvent.INVALIDATE, invalidate);
				}
				_fill = value;
				if(_fill) {
					_fill.addEventListener(InvalidationEvent.INVALIDATE, invalidate);
				}
				invalidate();
			}
		}
		
		/** 
		 * The border stroke of the component. If assigned, the border stroke is applied to the full width and height of the component
		 * during rendering.
		 */
		[AnimateableChild]
		public function get stroke():IStroke {
			return _stroke;
		}
		public function set stroke(value:IStroke):void {
			if(_stroke != value) {
				if(_stroke) {
					_stroke.removeEventListener(InvalidationEvent.INVALIDATE, invalidate);
				}
				_stroke = value;
				if(_stroke) {
					_stroke.addEventListener(InvalidationEvent.INVALIDATE, invalidate);
				}
				invalidate();
			}
		}
		
		/** @private */
		public function get borderExpand():int {
			return _borderExpand;
		}
		/**  @private */
		public function set borderExpand(value:int):void {
			if(value != _borderExpand) {
				_borderExpand = value;
				invalidate();
			}
		}
		
		/** Whether to apply a mask to the full width and height of the component during rendering (default false). */
		public function get clip():Boolean {
			return _clip;
		}
		public function set clip(value:Boolean):void {
			if(value != _clip) {
				_clip = value;
				invalidate();
			}
		}
		
		/** The tooltip string of the component. The tooltip is shown when the mouse cursor hovers over the component. */
		public function get tooltip():String {
			return _tooltip;
		}
		public function set tooltip(value:String):void {
			if(_tooltip != value) {
				TooltipManager.instance.hideTooltip(this);
				_tooltip = value;
				if(_tooltip && _tooltip.length && !disabled) {
					interactive = true;
					if(isStateActive(STATE_OVER)) {
						TooltipManager.instance.showTooltip(this);
					}
				}
			}
		}
		
		/** @inheritDoc */
		override public function get tabIndex():int {
			return _tabIndex;
		}
		override public function set tabIndex(value:int):void {
			_tabIndex = value;
			if(focusElement) {
				super.tabIndex = -1;
				focusElement.tabIndex = value;
			} else {
				super.tabIndex = value;
			}
		}
		
		/** @private */
		public function get focusElement():InteractiveObject {
			return _focusElement;
		}
		/**  @private */
		public function set focusElement(value:InteractiveObject):void {
			if(value != _focusElement) {
				_focusElement = value;
				tabIndex = _tabIndex;
			}
		}

		
		// ----------------- states ---------------------
		
		/** Whether the component is disabled */
		[Bindable]
		public function get disabled():Boolean {
			return _disabled;
		}
		public function set disabled(value:Boolean):void {
			_disabled = value;
			if(_disabled) {
				addState(STATE_DISABLED);
			} else {
				removeState(STATE_DISABLED);
			}
		}
		
		private function mouseOver(e:MouseEvent):void {
			addState(STATE_OVER);
			if(pressed) {
				addState(STATE_DOWN);
			}
			if(_tooltip && !disabled) {
				TooltipManager.instance.showTooltip(this);
			}
		}
		
		private function mouseOut(e:MouseEvent):void {
			removeState(STATE_DOWN);
			removeState(STATE_OVER);
			if(_tooltip) {
				TooltipManager.instance.hideTooltip(this);
			}
		}
		
		private function mouseDown(e:MouseEvent):void {
			addState(STATE_DOWN);
			pressed = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpAfterPress);
			TooltipManager.instance.hideTooltip(this);
		}
		
		private function mouseUpAfterPress(event:MouseEvent):void {
			pressed = false;
			removeState(STATE_DOWN);
			if(stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpAfterPress);
			}
		}
		
		private function mouseUp(e:MouseEvent):void {
			removeState(STATE_DOWN);
		}
		
		private function focusIn(e:FocusEvent):void {
			if(focusable) {
				if(_focusElement) {
					stage.focus = _focusElement;
				}
				addState(STATE_FOCUS);
			}
		}
		
		private function focusOut(e:FocusEvent):void {
			removeState(STATE_FOCUS);
		}
		
		/** @private */ 
		public function get includeAsChild():Boolean {
			if(_active) {
				return true;
			}
			if(_transition) {
				return _transition.active;
			}
			return false;
		}

		/** 
		 * Whether the component is active (included in rendering) or inactive (excluded from rendering). The default value
		 * is true.
		 */
		[Bindable]
		public function get active():Boolean {
			return _active;
		}
		public function set active(value:Boolean):void {
			_active = value;
			if(_transition) {
				if(!_active) {
					_transition.hide();
				} else {
					_transition.show();
					reportActivityChange();
				}
			} else {
				reportActivityChange();
			}
		}
		
		private function reportActivityChange(e:Event = null):void {
			dispatchEvent(new StateEvent(StateEvent.ACTIVITY_CHANGE));
		}
		
		/**
		 * The transition of the component. The transition is applied whenever the active-property of the component is
		 * changed. Setting this property will enable you to create a smooth tween (fade or effect) when the component
		 * changes it's active-property. 
		 */		
		public function get transition():FadeTransition {
			return _transition;
		}
		public function set transition(value:FadeTransition):void {
			if(_transition != value) {	
				if(_transition) {
					_transition.removeEventListener(Event.COMPLETE, reportActivityChange);
				}
				_transition = value;
				_transition.target = this;
				_transition.addEventListener(Event.COMPLETE, reportActivityChange);
			} 
		}
		
		/** Override this to validate your components properties. */
		public function validateProperties():void {
			if(!_currentState && _states.length) {
				addState(_states[0].name);
			}
		}
		
		/*--------------- States support ---------------*/
		
		/** The states that this component supports */		
		[Inspectable(name="states", category="Common")]
		public function get states():Array {
			return _states;
		}
		public function set states(value:Array):void {
			_states = value;
			_currentState = "";
			statesActive = new Vector.<State>();
			if(_states && _states.length) {
				for(var i:int = 0; i<addedStatesBeforeInit.length; i++) {
					addState(addedStatesBeforeInit[i]);
				}
				addedStatesBeforeInit = [];
				invalidateProperties(true);
			}
		}
		
		/**
		 * In addition to setting the currentState property of a component directly, Flow supports adding and removing states the addState and
		 * removeState methods. When applied this way, the currentState property will be assigned the state with the highest priority (defined last
		 * in the states-properties). 
		 * @param The state's name to add.
		 * 
		 * @example Your component has three states: up, down and disabled
		 * <listing version="3.0">
		 * addState("up"); // currentState is 'up'
		 * addState("disabled"); // currenState is 'disabled'
		 * addState("down"); // currenState is 'disabled'
		 * removeState("disabled") // currentState is 'down'
		 * </listing>
		 * 
		 * @see #removeState()
		 * @see #currentState
		 */
		public function addState(stateName:String):void {
			if(states.length) {
				if(!statesActive.length && states.length) {
					
					statesActive.push(states[0]);
					checkState();
				}
				var state:State = getState(stateName);
				if(state) {
					if(statesActive.indexOf(state) == -1) {
						statesActive.push(state);
						checkState();
					}
				}
			} else {
				addedStatesBeforeInit.push(stateName);
			}
		}
		
		/**
		 * In addition to setting the currentState property of a component directly, Flow supports adding and removing states the addState and
		 * removeState methods. When applied this way, the currentState property will be assigned the state with the highest priority (defined last
		 * in the states-properties). 
		 * @param The state's name to remove.
		 * @see #addState()
		 * @see #currentState
		 */		
		public function removeState(stateName:String):void {
			if(states) {
				var state:State = getState(stateName);
				if(state && statesActive.indexOf(state) != -1) {
					statesActive.splice(statesActive.indexOf(state), 1);
					checkState();
				}
			} else {
				var index:int = addedStatesBeforeInit.indexOf(stateName);
				if(index != -1) {
					addedStatesBeforeInit.splice(index,1);
				}
			}
		}
		
		/**
		 * Checks if the component has a state with the given name.
		 * @param The name of the state to check.
		 * @return True if the state exists, false otherwise.
		 * 
		 */		
		public function hasState(stateName:String):Boolean {
			for(var i:int = 0; i<states.length; i++) {
				if(states[i].name == stateName) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Returns a state with the given name.
		 * @param The name of the state to fetch.
		 * @return The state or null, if no state with such a name exists.
		 */		
		public function getState(state:String):State {
			for(var i:int = 0; i<states.length; i++) {
				if(states[i].name == state) {
					return states[i];
				}
			}
			return null;
		}
		
		/**
		 * Checks if a state has been added to the component using the addState-method. 
		 * @param The name of the state to check.
		 * @return True if the state has been added, false otherwise.
		 */		
		public function isStateActive(stateName:String):Boolean {
			for(var i:int = 0; i<statesActive.length; i++) {
				if(statesActive[i].name == stateName) {
					return true;
				}
			}
			return false;
		}
		
		/** @private */
		protected function checkState():void {
			var maxFound:int = -1;
			for(var i:int = 0; i<statesActive.length; i++) {
				maxFound = Math.max(_states.indexOf(statesActive[i]), maxFound);
			}
			if(maxFound > -1) {
				currentState = _states[maxFound].name;
			}
		}
		
		/** The current state of the component. Set this property to change the state of the component and apply all overrides. */		
		[Bindable]
		public function get currentState():String {
			return _currentState;
		}
		public function set currentState(value:String):void {
			if(value != _currentState) {
				for(var i:int = 0; i<states.length; i++) {
					if(states[i].name == _currentState) {
						var fromState:State = states[i];
					}
					if(states[i].name == value) {
						var toState:State = states[i];
					}
				}
				if(fromState && toState) {
					if( toState.transitionSpeed) {
						manager.beginAnimation(this);
					} else {
						manager.cancelAnimation(this);
					}
				} else {
					manager.cancelAnimation(this);
				}
			
				if(fromState) {
					fromState.remove(stateTarget);
				}
				
				var evt:StateEvent = new StateEvent(StateEvent.STATE_CHANGE);
				evt.fromState = _currentState;
				evt.toState = value;
				_currentState = value;
				
				if(toState) {
					toState.apply(stateTarget);
				
					if(fromState && toState.transitionSpeed) {
						manager.commitAnimation(toState.transitionSpeed);
					}
				}
				if(evt.fromState != "") {
					dispatchEvent(evt);
				}
				invalidate();
			}
		}
		
		/** @private */
		protected function get stateTarget():Component {
			return this;
		}
		
		/** @private */
		public function addStateClip(clip:MovieClip):void {
			if(!stateMovieClips) {
				stateMovieClips = new Vector.<MovieClip>();
				addEventListener(StateEvent.STATE_CHANGE, stateChanged);
			}
			stateMovieClips.push(clip);
		}
		
		/** @private */
		public function removeStateClip(clip:MovieClip):void {
			if(stateMovieClips.indexOf(clip) != -1) {
				stateMovieClips.splice(stateMovieClips.indexOf(clip), 1);
			}
			if(!stateMovieClips.length) {
				stateMovieClips = null;
				removeEventListener(StateEvent.STATE_CHANGE, stateChanged);
			} 
		}
		
		/** @private */
		protected function stateChanged(e:StateEvent):void {
			for(var i:int = 0; i<stateMovieClips.length; i++) {
				if(stateMovieClips[i].currentLabels.indexOf(e.toState)) {
					try {
						stateMovieClips[i].gotoAndPlay(e.toState);
					} catch (e:Error) {}
				}
			}
		}
		
		/**  @private */
		public function get transitions():Array {
			return [];
		}
		/** @private */
		public function set transitions(value:Array):void {
		}
		
		/** @private */
		public function newInstance():* {
			var klass:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			return new klass();
		}
		
		/** @private */
		public function copyInstance():* {
			var klass:Class = getDefinitionByName(getQualifiedClassName(this)) as Class;
			var instance:Component = new klass();
			for(var prop:String in this) {
				instance[prop] = this[prop];
			}
			return instance;
		}
		
		/** @private */
		public function get visualRepresentation():Component {
			return this;
		}
		
		[AnimateableChild]
		public function get effect():Effect {
			return _effect;
		}
		public function set effect(value:Effect):void {
			if(value != _effect) {
				if(_effect) {
					_effect.target = null;
				}
				_effect = value;
				if(_effect) {
					_effect.target = this;
				}
			}
		}
	}
	Component.manager = LayoutManager.instance;
}