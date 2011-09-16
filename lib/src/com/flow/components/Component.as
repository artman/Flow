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
	
	import com.flow.components.graphics.fills.IFill;
	import com.flow.components.graphics.strokes.IStroke;
	import com.flow.containers.Container;
	import com.flow.effects.transitions.FadeTransition;
	import com.flow.events.ComponentEvent;
	import com.flow.events.InvalidationEvent;
	import com.flow.events.StateEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.core.IStateClient2;
	import mx.states.State;
	
	[DefaultProperty("background")]
	[Event(name="stateChange", type="com.flow.events.StateEvent")]
	public class Component extends Sprite implements IStateClient2 {
		
		public static const STATE_NORMAL:String = "normal";
		public static const STATE_HOVER:String = "hover";
		public static const STATE_DOWN:String = "down";
		public static const STATE_FOCUS:String = "focus";
		public static const STATE_DISABLED:String = "disabled";
		
		public static var manager:LayoutManager;
		
		protected var statesActive:Vector.<State>;
		
		public var hasExplicitWidth:Boolean = false;
		public var hasExplicitHeight:Boolean = false;
		
		public var includeIn:String;
		
		protected var _top:MeasureUnit;
		protected var _bottom:MeasureUnit;
		protected var _left:MeasureUnit;
		protected var _right:MeasureUnit;
		
		protected var _verticalCenter:MeasureUnit;
		protected var _horizontalCenter:MeasureUnit;
		
		protected var _w:MeasureUnit;
		protected var _h:MeasureUnit;
		
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		
		protected var _measuredWidth:Number;
		protected var _measuredHeight:Number;
		
		protected var _absoluteWidth:Number;
		protected var _absoluteHeight:Number;
		
		protected var _minWidth:Number;
		protected var _minHeight:Number;
		protected var _maxWidth:Number;
		protected var _maxHeight:Number;
		
		private var _borderExpand:int = 0;
		
		public var propertiesInvalidated:Boolean = false;
		public var layoutInvalidated:Boolean = false;
		public var invalidated:Boolean = false;
		
		private var _measureUnits:MeasureUnits;
		
		private var _currentState:String = "";
		private var _disabled:Boolean = false;
		private var _interactive:Boolean = false;
		
		public var depth:int = 0;

		public var stateMovieClips:Vector.<MovieClip>;
		public var focusable:Boolean = false;
		
		private var _clip:Boolean = false;
		private var _visible:Boolean = true;
		
		protected var _active:Boolean = true;
		protected var _transition:FadeTransition;
		
		private var _states:Array = [];
		
		protected var _background:IFill;
		protected var _border:IStroke;
		
		private var _tooltip:String;
		
		[Bindable] public var data:*;
		
		[Event(name="creationComplete", type="com.flow.events.ComponentEvent")]
		public function Component() {
			super();
			statesActive = new Vector.<State>();
			_top = new MeasureUnit(null);
			_bottom = new MeasureUnit(null);
			_left = new MeasureUnit(null);
			_right = new MeasureUnit(null);
			_w = new MeasureUnit(null);
			_h = new MeasureUnit(null);
			_verticalCenter = new MeasureUnit(null);
			_horizontalCenter = new MeasureUnit(null);
			preInitialize();
			manager.invalidateInit(this);
			invalidateProperties();
		}
		
		public final function init():void {
			initialize();
			dispatchEvent(new ComponentEvent(ComponentEvent.CREATION_COMPLETE));
		}
		
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
			}
		}

		protected function preInitialize():void {
			// Override
		}
		
		protected function initialize():void {
			// Override
		}

		public function invalidate(e:Event = null):void {
			if(!invalidated) {
				invalidated = true;	
				manager.invalidateComponent(this);
			}
		}
		
		public function invalidateTree():void {
			invalidateLayout();
		}
		
		public function invalidateLayout(fromChild:Boolean = false):void {
			if(parent is Container) {
				(parent as Container).invalidateLayout();
			}
		}
		
		public function invalidateProperties(layoutValidationRequired:Boolean = true):void {
			propertiesInvalidated = true;
			if(layoutValidationRequired) {
				invalidateLayout();
			}
			invalidate();
		}
		
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
					var w:int = sanitizeWidth(!isNaN(_absoluteWidth) ? _absoluteWidth : _measuredWidth);
					var h:int = sanitizeHeight(!isNaN(_absoluteHeight) ? _absoluteHeight : _measuredHeight);
					draw(w, h);
				} else {
					if(super.visible) {
						super.visible = false;
					}
				}
			}
			invalidated = false;
		}
		
		protected function checkVisibility():Boolean {
			var w:int = sanitizeWidth(!isNaN(_absoluteWidth) ? _absoluteWidth : _measuredWidth);
			var h:int = sanitizeHeight(!isNaN(_absoluteHeight) ? _absoluteHeight : _measuredHeight);
			if(w>0 && h>0) {
				return true
			}
			return false;
		}
		
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
		
		public function measure():void {
			// Override	
		}
		
		protected function draw(width:int, height:int):void {
			graphics.clear();
			if(_background) {
				_background.beginDraw(graphics, width, height);
			}
			if(_border) {
				_border.beginDraw(graphics, width, height);
			}
			if(_background || _border) {
				var widthExt:int = 0;
				if(_borderExpand) {
					widthExt = _borderExpand * 2 - 1;
				}
				graphics.drawRect(-borderExpand,-borderExpand, width + widthExt, height + widthExt);
			}
			if(_background) {
				_background.endDraw(graphics);
			}
			if(_border) {
				_border.endDraw(graphics);
			}
			applyMask(width, height);
		}
		
		protected function applyMask(width:int, height:int):void {
			if(clip) {
				var inset:int = 0;
				if(_border) {
					inset = Math.ceil(_border.thickness/2);
				}
				scrollRect = new Rectangle(0, 0, width+inset, height+inset);
			}
		}
		
		
		/*---------------- Measure --------------------*/
		
		public function sanitizeWidth(value:Number):Number {
			return (isNaN(_minWidth) || value > _minWidth) ? ((isNaN(_maxWidth) || value < _maxWidth) ? value : _maxWidth) : _minWidth;
		}
		
		public function sanitizeHeight(value:Number):Number {
			return (isNaN(_minHeight) || value > _minHeight) ? ((isNaN(_maxHeight) || value < _maxHeight) ? value : _maxHeight) : _minHeight;
		}
		
		
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
		
		[Bindable(event="widthChange")] [PercentProxy("percentWidth")]
		override public function get width():Number {
			if(!_w.isNull && !_w.isPercentage) {
				return sanitizeWidth(_w.unit);
			}
			return sanitizeWidth(absoluteWidth ? absoluteWidth : measuredWidth ? measuredWidth : 0);
		}
		override public function set width(value:Number):void {
			value = Math.round(value);
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
		
		[Bindable(event="heightChange")] [PercentProxy("percentHeight")]
		override public function get height():Number {
			if(!_h.isNull && !_h.isPercentage) {
				return sanitizeHeight(_h.unit);
			}
			return sanitizeHeight(absoluteHeight ? absoluteHeight : measuredHeight ? measuredHeight : 0);
		}
		override public function set height(value:Number):void {
			value = Math.round(value);
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
		
		public function get minWidth():Number {
			return _minWidth;
		}
		public function set minWidth(value:Number):void {
			if(value != _minWidth) {
				_minWidth = value;
				invalidateLayout();
			}
		}
		
		public function get minHeight():Number {
			return _minHeight;
		}
		public function set minHeight(value:Number):void {
			if(value != _minHeight) {
				_minHeight = value;
				invalidateLayout();
			}
		}
		
		public function get maxWidth():Number {
			return _maxWidth;
		}
		public function set maxWidth(value:Number):void {
			if(value != _maxWidth) {
				_maxWidth = value;
				invalidateLayout();
			}
		}
		
		public function get maxHeight():Number {
			return _maxHeight;
		}
		public function set maxHeight(value:Number):void {
			if(value != _maxHeight) {
				_maxHeight = value;
				invalidateLayout();
			}
		}
		
		public function get measuredWidth():Number {
			return _measuredWidth;
		}
		public function set measuredWidth(value:Number):void {
			if(value != _measuredWidth) {
				var oldWidth:int = width;
				_measuredWidth = value;
				if(width != oldWidth) {
					invalidate();
				}
				if(hasEventListener("widthChange")) {
					dispatchEvent(new Event("widthChange"));
				}
			}
		}
		
		public function get measuredHeight():Number {
			return _measuredHeight;
		}
		public function set measuredHeight(value:Number):void {
			if(value != _measuredHeight) {
				var oldHeight:int = height;
				_measuredHeight = value;
				if(height != oldHeight) {
					invalidate();
				}
				if(hasEventListener("heightChange")) {
					dispatchEvent(new Event("heightChange"));
				}
			}
		}

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
		
		[Exclude(name="absoluteWidth", kind="property")]
		public function get absoluteWidth():int {
			return _absoluteWidth;
		}
		public function set absoluteWidth(value:int):void {
			if(_absoluteWidth != value) {
				_absoluteWidth = value;
				invalidate();
				if(hasEventListener("widthChange")) {
					dispatchEvent(new Event("widthChange"));
				}
			}
		}
		
		[Exclude(name="absoluteHeight", kind="property")]
		public function get absoluteHeight():int {
			return _absoluteHeight;
		}
		public function set absoluteHeight(value:int):void {
			if(_absoluteHeight != value) {
				_absoluteHeight = value;
				invalidate();
				if(hasEventListener("heightChange")) {
					dispatchEvent(new Event("heightChange"));
				}
			}
		}
		
		[Bindable]
		override public function get x():Number {
			return _x;
		}
		override public function set x(value:Number):void {
			_x = value;
			super.x = Math.round(value);
		}
		
		[Bindable]
		override public function get y ():Number {
			return _y;
		}
		override public function set y (value:Number):void {
			_y = value;
			super.y = Math.round(value);
		}
		
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
		
		public function get background():IFill {
			return _background;
		}
		public function set background(value:IFill):void {
			if(_background != value) {
				if(_background) {
					_background.removeEventListener(InvalidationEvent.INVALIDATE, invalidate);
				}
				_background = value;
				if(_background) {
					_background.addEventListener(InvalidationEvent.INVALIDATE, invalidate);
				}
				invalidate();
			}
		}
		
		public function get border():IStroke {
			return _border;
		}
		public function set border(value:IStroke):void {
			if(_border != value) {
				if(_border) {
					_border.removeEventListener(InvalidationEvent.INVALIDATE, invalidate);
				}
				_border = value;
				if(_border) {
					_border.addEventListener(InvalidationEvent.INVALIDATE, invalidate);
				}
				invalidate();
			}
		}
		
		public function get borderExpand():int {
			return _borderExpand;
		}
		
		public function set borderExpand(value:int):void {
			if(value != _borderExpand) {
				_borderExpand = value;
				invalidate();
			}
		}
		
		public function get clip():Boolean {
			return _clip;
		}
		public function set clip(value:Boolean):void {
			if(value != _clip) {
				_clip = value;
				invalidate();
			}
		}
		
		public function get tooltip():String {
			return _tooltip;
		}
		public function set tooltip(value:String):void {
			if(_tooltip != value) {
				TooltipManager.instance.hideTooltip(this);
				_tooltip = value;
				if(_tooltip && _tooltip.length) {
					interactive = true;
					if(isStateActive(STATE_HOVER)) {
						TooltipManager.instance.showTooltip(this);
					}
				}
			}
		}

		
		// ----------------- states ---------------------
		
		
		public function get disabled():Boolean {
			return _disabled;
		}
		public function set disabled(value:Boolean):void {
			if(_disabled != value) {
				_disabled = value;
				if(_disabled) {
					addState(STATE_DISABLED);
				} else {
					removeState(STATE_DISABLED);
				}
			}
		}
		
		private function mouseOver(e:MouseEvent):void {
			addState(STATE_HOVER);
			if(_tooltip) {
				TooltipManager.instance.showTooltip(this);
			}
		}
		
		private function mouseOut(e:MouseEvent):void {
			removeState(STATE_DOWN);
			removeState(STATE_HOVER);
			if(_tooltip) {
				TooltipManager.instance.hideTooltip(this);
			}
		}
		
		private function mouseDown(e:MouseEvent):void {
			addState(STATE_DOWN);
			TooltipManager.instance.hideTooltip(this);
		}
		
		private function mouseUp(e:MouseEvent):void {
			removeState(STATE_DOWN);
		}
		
		private function focusIn(e:FocusEvent):void {
			if(focusable) {
				addState(STATE_FOCUS);
			}
		}
		
		private function focusOut(e:FocusEvent):void {
			removeState(STATE_FOCUS);
		}
		
		public function get includeAsChild():Boolean {
			if(_active) {
				return true;
			}
			if(_transition) {
				return _transition.active;
			}
			return false;
		}

		public function get active():Boolean {
			return _active;
		}
		public function set active(value:Boolean):void {
			if(_active != value) {
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
		}
		
		private function reportActivityChange(e:Event = null):void {
			dispatchEvent(new StateEvent(StateEvent.ACTIVITY_CHANGE));
		}
		
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
		
		public function validateProperties():void {
			// Override
		}
		
		
		
		/*--------------- States support ---------------*/
		
		[Inspectable(name="states", category="Common")]
		public function get states():Array {
			return _states;
		}
		
		public function set states(value:Array):void {
			_states = value;
			if(_states && _states.length) {
				addState(_states[0].name, false);
			}
		}
		
		public function addState(stateName:String, updateCurrentState:Boolean = true):void {
			var state:State = getState(stateName);
			if(state) {
				if(statesActive.indexOf(state) == -1) {
					statesActive.push(state);
					if(updateCurrentState) {
						checkState();
					}
				}
			}
		}
		
		public function removeState(stateName:String):void {
			var state:State = getState(stateName);
			if(state && statesActive.indexOf(state) != -1) {
				statesActive.splice(statesActive.indexOf(state), 1);
				checkState();
			}
		}
		
		public function hasState(stateName:String):Boolean {
			for(var i:int = 0; i<states.length; i++) {
				if(states[i].name == stateName) {
					return true;
				}
			}
			return false;
		}
		
		public function getState(state:String):State {
			for(var i:int = 0; i<states.length; i++) {
				if(states[i].name == state) {
					return states[i];
				}
			}
			return null;
		}
		
		public function isStateActive(stateName:String):Boolean {
			for(var i:int = 0; i<statesActive.length; i++) {
				if(statesActive[i].name == stateName) {
					return true;
				}
			}
			return false;
		}
		
		protected function checkState():void {
			var maxFound:int = -1;
			for(var i:int = 0; i<statesActive.length; i++) {
				maxFound = Math.max(states.indexOf(statesActive[i]), maxFound);
			}
			if(maxFound > -1) {
				currentState = states[maxFound].name;
			}
		}
		
		public function get currentState():String {
			return _currentState;
		}
		
		public function set currentState(value:String):void {
			if(value != _currentState) {
				for(var i:int = 0; i<states.length; i++) {
					if(states[i].name == _currentState) {
						(states[i] as State).remove(this);
					}
				}
				
				var evt:StateEvent = new StateEvent(StateEvent.STATE_CHANGE);
				evt.fromState = _currentState;
				evt.toState = value;
				_currentState = value;
				
				for(i = 0; i<states.length; i++) {
					if(states[i].name == _currentState) {
						(states[i] as State).apply(this);
					}
				}				
				dispatchEvent(evt);
			}
		}
		
		public function addStateClip(clip:MovieClip):void {
			if(!stateMovieClips) {
				stateMovieClips = new Vector.<MovieClip>();
				addEventListener(StateEvent.STATE_CHANGE, stateChanged);
			}
			stateMovieClips.push(clip);
		}
		
		
		public function removeStateClip(clip:MovieClip):void {
			if(stateMovieClips.indexOf(clip) != -1) {
				stateMovieClips.splice(stateMovieClips.indexOf(clip), 1);
			}
			if(!stateMovieClips.length) {
				stateMovieClips = null;
				removeEventListener(StateEvent.STATE_CHANGE, stateChanged);
			} 
		}
		
		protected function stateChanged(e:StateEvent):void {
			for(var i:int = 0; i<stateMovieClips.length; i++) {
				if(stateMovieClips[i].currentLabels.indexOf(e.toState)) {
					stateMovieClips[i].gotoAndPlay(e.toState);
				}
			}
		}
		
		/**
		 * @private 
		 */
		public function get transitions():Array {
			return [];
		}
		public function set transitions(value:Array):void {
		}
	}
	Component.manager = LayoutManager.instance;
}