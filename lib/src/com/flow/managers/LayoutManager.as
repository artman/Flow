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

package com.flow.managers {
	
	import com.flow.collections.IList;
	import com.flow.components.Component;
	import com.flow.containers.Application;
	import com.flow.containers.Container;
	import com.flow.effects.Effect;
	import com.flow.graphics.GradientData;
	import com.flow.motion.AnimationProperties;
	import com.flow.motion.AnimationProperty;
	import com.flow.motion.IAnimateable;
	import com.flow.motion.Tween;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * The layout manager is a Singleton and takes care of commandeering layout and rendering. Most of it's methods are internal and should
	 * not be called by the developer.
	 */	
	public class LayoutManager {
		
		public static const LAYOUT_PHASE_NONE:int = 0;
		public static const LAYOUT_PHASE_VALIDATING:int = 1;
		
		private static var animateableChildrenLookup:Dictionary = new Dictionary();
		
		/** The Singleton instance created upon startup */
		public static var instance:LayoutManager = new LayoutManager();
		
		/** @private */
		public var layoutPhase:int = 0;
		private var invalidInitList:Vector.<Component>;
		private var invalidList:Vector.<Component>;
		private var invalidLayoutList:Vector.<Container>;
		private var invalidChildrenList:Vector.<Container>;
		private var invalidEffectList:Vector.<Effect>;
		private var root:Stage;
		private var lastUpdate:Number;
		/** @private */
		public var deltaTime:Number;
		private var invalidated:Boolean = false;
		private var animationRoot:Component;
		private var animationProperties:Dictionary;
		private var animatedComponents:Dictionary;
		
		/** Constructor */
		public function LayoutManager() {
			invalidInitList = new Vector.<Component>();
			invalidList = new Vector.<Component>();
			invalidLayoutList = new Vector.<Container>();
			invalidEffectList = new Vector.<Effect>();
			invalidChildrenList = new Vector.<Container>();
			animatedComponents = new Dictionary(true);
		}
		
		/** @private */
		public function initialize(root:Stage):void {
			this.root = root;
			root.addEventListener(Event.RENDER, validate);
			root.addEventListener(Event.RESIZE, resize);
			root.addEventListener(Event.FULLSCREEN, resize);
			root.addEventListener(Event.ENTER_FRAME, enterFrame, false, 1000);
		}
		
		private function resize(e:Event = null):void {
			Application.application.width = root.stageWidth;
			Application.application.height = root.stageHeight;
			validate();
		}
		
		/** @private */
		public function invalidateInit(component:Component):void {
			if(invalidInitList.indexOf(component) == -1) {
				invalidInitList.push(component);
			}
			if(!invalidated) {
				invalidate();
			}
		}
		
		/** @private */
		public function invalidateComponent(component:Component):void {
			if(invalidList.indexOf(component) == -1) {
				invalidList.push(component);
			}
			if(!invalidated) {
				invalidate();
			}
		}
		
		/** @private */
		public function invalidateEffect(effect:Effect):void {
			if(invalidEffectList.indexOf(effect) == -1) {
				invalidEffectList.push(effect);
			}
			if(!invalidated) {
				invalidate();
			}
		}
		
		/** @private */
		public function invalidateLayout(container:Container):void {
			if(invalidLayoutList.indexOf(container) == -1) {
				invalidLayoutList.push(container);
			}
			if(!invalidated) {
				invalidate();
			}
		}
		
		/** @private */
		public function invalidateChildren(container:Container):void {
			if(invalidChildrenList.indexOf(container) == -1) {
				invalidChildrenList.push(container);
			}
			if(!invalidated) {
				invalidate();
			}
		}
		
		private function invalidate():void {
			if(root) {
				root.stage.invalidate();
			}
			invalidated = true;
		}
		
		/** @private */
		public function validate(e:Event = null):void {
			while(invalidChildrenList.length) {
				invalidChildrenList.shift().validateChildren();
			}
			while(invalidInitList.length) {
				invalidInitList.shift().init();
			}
			// Second loop over children if init created some
			while(invalidChildrenList.length) {
				invalidChildrenList.shift().validateChildren();
			}
			
			layoutPhase = LAYOUT_PHASE_VALIDATING;
			invalidLayoutList.sort(depthSort);
			while(invalidLayoutList.length) {
				var container:Container = invalidLayoutList.shift();
				if(container.layoutInvalidated) {
					container.validateLayoutOnRoot();
				}
			}
			while(invalidList.length) {
				var component:Component = invalidList.shift();
				if(component.invalidated) {
					component.validate();
				}
			}
			
			while(invalidEffectList.length) {
				var effect:Effect = invalidEffectList.shift();
				if(effect.invalidated) {
					effect.validate();
				}
			}

			invalidated = false;
			layoutPhase = LAYOUT_PHASE_NONE;
			
			if(invalidChildrenList.length || invalidLayoutList.length) {
				// Reloop
				validate();
			}
		}
		
		private function depthSort(a:Component, b:Component):int {
			if(a.depth == b.depth) {
				return 0
			} else if(a.depth < b.depth) {
				return -1;
			}
			return 0;
		}
		
		private function enterFrame(e:Event):void {
			if(!lastUpdate) {
				lastUpdate = getTimer();
			}
			var time:Number = getTimer();
			deltaTime = time - lastUpdate;
			lastUpdate = time;	
		}
		
		/**
		 * The layout manager instance let's you easily create animations from one state to the next. You call beginAnimation, make
		 * changes to any visual properties of the target or it's sub-display objects and call commitAnimation and Flow will animate
		 * the changes you've made. 
		 * 
		 * You can only open one animation session at a time. Any open animation-sessions will be commited when you call beginAnimation().
		 * 
		 * @param The target of the animation. This component and all it's children will be animated once you commit the animation.
		 * @see #commitAnimation()
		 */		
		public function beginAnimation(target:Component):void {
			if(animationRoot) {
				commitAnimation()
			}
			animationRoot = target;
			animationProperties = new Dictionary();
			collectProps(animationRoot, animationProperties);
		}
		
		
		/**
		 * Canceles a previously commited animation on the target, removing all effective tweens.

		 * @param The target to cancel. 
		 * @see #beginAnimation()
		 * @see #commitAnimation()
		 */		
		public function cancelAnimation(target:Component):void {
			if(animatedComponents[target]) {
				var props:Dictionary = new Dictionary();
				collectProps(target, props);
				for (var component:Object in props) {
					// TODO: Shouldn't remove all tweens, only tweens for animateable properties.
					Tween.removeTween(component);
				}
				animationRoot = null;
			}
		}
		
		/**
		 * Commits a previously opened animation. This will walk through the target component and all it's children looking for properties
		 * that have changed since you called beginAnimation and animate them.
		 * @param The speed at which to animate
		 * @param tweenProps Any properties you define will directly be passed the the Tween class as animation properties. This lets you
		 * for example define a easing function or delay for the animation.
		 * @see #beginAnimation()
		 */		
		public function commitAnimation(speed:Number = 0.5, tweenProps:Object = null):void {
			animatedComponents[animationRoot] = true;
			if(!tweenProps) {
				tweenProps = {};
			}
			var newAnimationProperties:Dictionary = new Dictionary();
			collectProps(animationRoot, newAnimationProperties);
	
			for (var component:Object in animationProperties) {
				var changedProps:Vector.<AnimationProperty> = (animationProperties[component] as AnimationProperties).parseChanges(newAnimationProperties[component]);
				if(changedProps) {
					(animationProperties[component] as AnimationProperties).applyToObject(component);
					new Tween(component, speed, changedProps, tweenProps);
				}
			}
			animationRoot = null;
			animationProperties = null;
		}
		
		private function collectProps(target:Object, dictionary:Dictionary):void {
			var props:AnimationProperties = new AnimationProperties();
			props.gatherProps(target);
			dictionary[target] = props;
			if(target is IAnimateable) {
				var name:String = IntrospectionManager.getClassName(target);
				if(!animateableChildrenLookup[name]) {
					var desc:XML = IntrospectionManager.getDescriptor(target);
					var childrenNames:Vector.<String> = new Vector.<String>();
					var lst:XMLList = desc..metadata.(@name == "AnimateableChild");
					for(var i:int = 0; i<lst.length(); i++) {
						childrenNames.push(lst[i].parent().@name);
					}
					animateableChildrenLookup[name] = childrenNames;
				}
				childrenNames = animateableChildrenLookup[name];
			
				for(i = 0; i<childrenNames.length; i++) {
					var child:* = target[childrenNames[i]];
					if(child) {
						if(child is Vector.<*> || child is Array) {
							for(var j:int = 0; j<child.length; j++) {
								collectProps(child[j], dictionary);
							}
						} else if(child is IList) {
							for(j = 0; j<child.length; j++) {
								collectProps((child as IList).getItemAt(j), dictionary);
							}
						} else {
							collectProps(child, dictionary)
						}
					}
				}
			} else if(target is DisplayObjectContainer) {
				var cnt:int = (target as DisplayObjectContainer).numChildren;
				for(i = 0; i<cnt; i++) {
					collectProps((target as DisplayObjectContainer).getChildAt(i), dictionary)
				}
			}
		}
	}
}