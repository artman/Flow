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

package com.flow.effects.transitions {
	
	import com.flow.components.Component;
	import com.flow.motion.Tween;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(name="complete", type="flash.events.Event")]
	public class FadeTransition extends EventDispatcher {
		
		public var speed:Number;
		public var speedOut:Number = 0;
		protected var _target:Component;	
		private var firstShow:Boolean = true;
		private var _active:Boolean = false;
		
		public function FadeTransition(speed:Number = 0.3) {
			this.speed = speed;
		}
		
		public final function get target():Component {
			return _target;
		}
		public final function set target(value:Component):void {
			if(value != _target) {
				_target = value;
			}
		}
		
		public final function show():void {
			if(_target) {
				if(firstShow) {
					firstShow = false;
					initTarget(_target);
				}
				_active = true;
				animateShow(speed);
			}
		}
		
		public final function hide():void {
			if(_target && _target.parent) {
				firstShow = false;
				_active = true;
				animateHide(speedOut != 0 ? speedOut : speed);
			} else {
				complete();
			}
		}
		
		final protected function complete(t:* = null):void {
			_active = false;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function initTarget(target:Component):void {
			target.alpha = 0;
		}
		
		public function animateShow(speed:Number):void {
			new Tween(target, speed, {alpha:1}).completeHandler = complete;
		}
		
		public function animateHide(speed:Number):void {
			var tween:Tween = new Tween(target, speedOut ? speedOut : speed, {alpha:0});
			tween.completeHandler = complete;
		}
		
		public function get active():Boolean {
			return _active;
		}
	}
}