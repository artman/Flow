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

package com.flow.effects {
	
	import com.flow.managers.LayoutManager;
	import com.flow.motion.Tween;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * The Effect class is used as a base-class for all kinds of visual effects and used extensively by Flow. An Effect is a visual
	 * transformation of a DisplayObject. In Flow, each effect can be animated in and out. This happend by changing the value-property
	 * of an Effect. A value of 0 means that the Effect shall not transform the DisplayObject at all, a value of 1 means that the 
	 * Effect is applied fully.
	 * 
	 * For example, a mask Effect with a value of 1 applied to a DisplayObject should make the DisplayObject invisible. A value of 0 would
	 * fully show the DisplayObject and a value of 0.5 should mask half of the DisplayObject.
	 */	
	[DefaultProperty("children")]
	public class Effect extends EventDispatcher{
		
		private var _value:Number;
		protected var _target:DisplayObject;
		private var _children:Vector.<Effect>;
		private var assignedFilters:Array = [];
		private var _alpha:Number;
		private var _followTargetAlpha:Boolean;
		
		/** @private */  
		public var parent:Effect = null;
		private var _composition:String = EffectComposition.SHARE_VALUE;
		public var invalidated:Boolean = false;
		private var propertiesInvalidated:Boolean;
		
		/**
		 * Constructor. Creates the Effect and optionally sets it's target DisplayObject. 
		 * @param The target of the effect.
		 */		
		public function Effect(target:DisplayObject = null){
			_children = new Vector.<Effect>();
			this.target = target;
			_alpha = 1;
			_value = 1;
			propertiesInvalidated = true;
		}
		
		/**
		 * The target of the Effect. Changing this porperty will make the Effect apply its visual transformation to a new object.
		 */		
		public function get target():DisplayObject {
			return _target;
		}
		public function set target(value:DisplayObject):void {
			if(value != _target) {
				if(_target) {
					dispose();
					_target.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
					_target.removeEventListener(Event.ADDED_TO_STAGE, validate);
				}
				_target = value;
				if(_target) {
					_target.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true);
					_target.addEventListener(Event.ADDED_TO_STAGE, validate);
					assignedFilters = _target.filters;
					invalidate();
				}
				for(var i:int = 0; i<_children.length; i++) {
					_children[i].target = _target;
				}
			}
		}
		
		/**
		 * Effect can be chained. Setting the children-property will add the passed Effect instances as children to the parent Effect.
		 * The childrens target will be assigned to all it's children. 
		 */		
		[ArrayElementType("com.flow.effects.Effect")]
		public function get children():Vector.<Effect> {
			return _children;
		}
		public function set children(value:Vector.<Effect>):void {
			_children = new Vector.<Effect>();
			for(var i:int = 0; i<value.length; i++) {
				addChild(value[i]);
			}
			invalidate();
		}
		
		/**
		 * Adds an Effect instance as a child to the parent Effect. The parent will assign it's target to the child instance. 
		 * @param The effect to add.
		 * @param How this effect should be compositioned.
		 * @see #composition
		 */		
		public function addChild(effect:Effect, composition:String = "shareValue"):void {
			effect.parent = this;
			effect.composition = composition;
			effect.target = target;
			children.push(effect);
		}
		
		private function removedFromStage(e:Event):void {
			target.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			dispose();
		}
		
		/**
		 * Setting this to true will interlock the target's alpha value with the value of the effect. When the target's alpha is 0, the value of the
		 * effect will be set to 1. When the target's alpha is 1, the value of the effect is set to 0.
		 * 
		 * Many effects work extremely well in conjunction with fading DisplayObjects in.
		 */		
		public function get followTargetAlpha():Boolean{
			return _followTargetAlpha;
		}
		public function set followTargetAlpha(value:Boolean):void {
			_followTargetAlpha = value;
			if(value) {
				addEventListener(Event.ENTER_FRAME, checkTargetAlpha, false, 0, true);
			} else {
				removeEventListener(Event.ENTER_FRAME, checkTargetAlpha);
			}
		}
		
		private function checkTargetAlpha():void {
			if(_target.alpha != _alpha){
				targetAlpha = _target.alpha;
				value = (1-targetAlpha);
			}
		}
		
		/**
		 * The value of the effect. 1 means that the effect is applied fully and 0 means that it's not applied at all.
		 */		
		public function get value():Number{
			return _value;
		}
		public function set value(val:Number):void{
			_value = val;
			invalidate();
		}
		
		/** @private */
		public function get targetAlpha():Number {
			return _alpha;
		}
		public function set targetAlpha(val:Number):void {
			_alpha = val;
			if(_target) {
				_target.alpha = val;
			}
			value = 1-val;
		}
		
		/**
		 * The composition of the effect in regards to it's parent.
		 * 
		 * EffectComposition.SHARE_VALUE will make the interlock the child's value-property
		 * with the parent's value-property. If you modify the value of the parent, the child will render with the same value.
		 * 
		 * EffectComposition.MULTIPLY will mutliply the child's value with the parent's value.
		 * 
		 * EffectComposition.INDEPENDENT will make the child's value independent from the parent's value.
		 */		
		public function get composition():String {
			return _composition;
		}
		public function set composition(value:String):void {
			if(value != _composition) {
				_composition = value;
				for(var i:int = 0; i<_children.length; i++) {
					_children[i].composition = _composition;
				}
			}
		}
		
		/**
		 * Subclasses should call invalidateProperties whenever they request their properties be validated through a call to
		 * validateProperties. Whenever properties are changed, the Effect should not immediately run through code that re-creates
		 * the Effect. Instead it should deffer its validation to the next event loop through a call to this method.
		 */		 
		protected function invalidateProperties():void {
			if(!propertiesInvalidated) {
				propertiesInvalidated = true;
				invalidate();
			}
		}
		
		/**
		 * This method is called whenever an Effect as requested that it's properties be validated.
		 */		
		protected function validateProperties():void {
			// Override
		}
		
		/**
		 * Whenever invalidate is called, the LayoutManager will make sure to call validate on the Effect instance in the next event loop. You should
		 * call the invalidate-method in subclasses whenever a property changes that requires the effect to be re-rendered.
		 */		
		protected function invalidate():void {
			if(!invalidated && _target) {
				LayoutManager.instance.invalidateEffect(this);
				invalidated = true;
			}
		}
		
		/** @private */
		public function validate(evt:Event = null):void {
			if(parent) {
				parent.validate(evt);
			} else {
				apply(_value);
			}
			invalidated = false;
		}
	
		private function apply(val:Number):Array{	
			if(propertiesInvalidated) {
				validateProperties();
				propertiesInvalidated = false;
			}
			var filters:Array = render(val);
			for(var i:Number = 0; i<children.length; i++) {
				var child:Effect = children[i];
				var childValue:Number = val;
				if(child.composition == EffectComposition.INDEPENDENT) {
					childValue = child.value;
				} else if(child.composition == EffectComposition.MULTIPLY) {
					childValue = child.value * val;
				}
				filters = filters.concat(child.apply(childValue));
			}
			if(parent){
				return filters;
			} else {
				filters = filters.concat(assignedFilters);
				if(_target) {
					_target.filters = filters;
				}
			}
			return null;
		}
		
		/**
		 * Render is called whenever the Effect needs to apply it's visual transformation to the target. 
		 * @param The value to render with. You should not rely on the value-property of the Effect, as the Effect might be chained to a parent.
		 * @return An array of Filters that the Effect wants to have applied to the target. This is required as Effects might be chained and
		 * there might be other Effects that want to add Filters to the DisplayObject. In case the Effect doesn't use filters, you should apply
		 * any visual changes to the target object directly.
		 */		
		protected function render(val:Number):Array {
			return new Array();
		}
		
		/**
		 * Fades the target in and inversly applies the effect. 
		 * @param The speed in seconds of the fade
		 * @param Any parameters to pass to the Tween as options
		 * @return The Tween instance that'll take care of fading the target.
		 */		
		public function fadeTargetIn(speed:Number, params:Object = null):Tween {
			return new Tween(this, speed, {targetAlpha:1}, params); 
		}
		
		/**
		 * Fades the target out and inversly applies the effect. 
		 * @param The speed in seconds of the fade
		 * @param Any parameters to pass to the Tween as options
		 * @return The Tween instance that'll take care of fading the target.
		 */	
		public function fadeTargetOut(speed:Number, params:Object = null):Tween{
			return new Tween(this, speed, {targetAlpha:0}, params); 
		}

		/**
		 * Animates the effect in, i.e. animates value to 1. 
		 * @param The speed in seconds of the animation
		 * @param Any parameters to pass to the Tween as options
		 * @return The Tween instance that'll take care of animating the value-property.
		 */	
		public function animateIn(speed:Number, params:Object = null):Tween {
			return new Tween(this, speed, {value:1}, params); 
		}

		/**
		 * Animates the effect out, i.e. animates value to 0. 
		 * @param The speed in seconds of the animation
		 * @param Any parameters to pass to the Tween as options
		 * @return The Tween instance that'll take care of animating the value-property.
		 */	
		public function animateOut(speed:Number, params:Object = null):Tween {
			return new Tween(this, speed, {value:0}, params); 
		}
		
		/** @private */  	
		public function dispose():void {
			_target.filters = assignedFilters;
		}	
	}
}