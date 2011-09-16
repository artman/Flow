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

package com.flow.motion {
	
	import com.flow.motion.easing.Quadratic;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	public class Tween extends EventDispatcher {

		public static var defaultEase:Function = Quadratic.easeOut
		protected static var currentTime:Number;
		protected static var activeTweens:Vector.<Tween>;
	
		private var _delay:Number=0;
		private var _values:Object;
		private var _position:Number;
		protected var inited:Boolean;
		protected var startValues:Object;
		protected var deltaValues:Object;

		public var duration:Number;
		public var ease:Function;
		public var target:Object;		
		public var completeHandler:Function;
		public var changeHandler:Function;
		
		public static function staticInit(root:Sprite):void {
			root.addEventListener(Event.ENTER_FRAME, tick);
			activeTweens =  new Vector.<Tween>;
			currentTime = getTimer() / 1000;
		}
		
		protected static function tick(evt:Event):void {
			var lastUpdate:Number = currentTime;
			currentTime = getTimer() / 1000;
			var deltaTime:Number = (currentTime-lastUpdate);
			for(var i:int = activeTweens.length-1; i>=0; i--) {
				activeTweens[i].position = activeTweens[i]._position + deltaTime;
			}
		}
		
		protected static function tweenCompleted(tween:Tween):void {
			var index:int = activeTweens.indexOf(tween);
			if(index != -1) {
				activeTweens.splice(index, 1);
			}
		}
		
		public function Tween(target:Object=null, duration:Number=1, values:Object=null, props:Object=null) {
			this.ease = defaultEase;
			this.target = target;
			this.duration = duration;
			this._values = values;
			this._position = 0;
			var dontOverride:Boolean = false;
			if (props) {
				dontOverride = props.dontOverride; 
				if(props.delay) {
					delay = props.delay;
				}
				if(props.ease) {
					ease = props.ease;
				}
				if(props.autoInit) {
					init();
				}
			}
			if(!dontOverride) {
				for(var value:String in values) {
					for(var i:int = activeTweens.length-1; i>=0; i--) {
						if(activeTweens[i].target == this.target) {
							activeTweens[i].deleteValue(value);
						}
					}
				}
			}
			activeTweens.splice(0, 0, this);
			if (this.duration == 0 && delay == 0) { 
				position=0; 
			}
		}
		

		public function get position():Number {
			return _position;
		}
		public function set position(value:Number):void {
			var end:Boolean = (value >= duration);
			if (end) {
				_position = duration;
			} else {
				_position = value;
			}
			var ratio:Number = (duration == 0 && _position >= 0) ? 1 : ease(_position / duration, 0, 1, 1);
			if (target && _position >= 0) {
				if (!inited) { 
					init();
				}
				for (var prop:String in _values) {
					target[prop] = startValues[prop] + deltaValues[prop] * ratio;
				}
			}
			if (changeHandler != null) { 
				changeHandler(this); 
			}
			if (end) {
				tweenCompleted(this);
				if (completeHandler != null) { 
					completeHandler(this); 
				}
			}
		}
		
		public function get delay():Number {
			return _delay;
		}
		public function set delay(value:Number):void {
			if (_position <= 0) {
				_position = -value;
			}
			_delay = value;
		}
		
		public function deleteValue(name:String):Boolean {
			if(deltaValues) {
				delete(deltaValues[name]);
				delete(startValues[name]);
			}
			if(_values) {
				delete(_values[name]);
			}
			var cnt:int = 0;
			for(var val:String in _values) {
				cnt ++;
			}
			if(!cnt) {
				tweenCompleted(this);
				return true;
			}
			return false;
		}
	
		public function init():void {
			inited = true;
			startValues = {};
			deltaValues = {};
			for (var prop:String in _values) {
				deltaValues[prop] = _values[prop] - (startValues[prop] = target[prop]);
			}
		}
		
		public static function removeTween(target:Object):void {
			for(var i:int = activeTweens.length-1; i>=0; i--) {
				if(activeTweens[i].target == target) {
					tweenCompleted(activeTweens[i]);
				}
			}
		}
		
		public static function removeProperties(target:Object, prop:*):void {
			if(!(prop is Array)) {
				prop = [prop];
			}
			for(var i:int = activeTweens.length-1; i>=0; i--) {
				if(activeTweens[i].target == target) {
					for(var j:int = 0; j<prop.length; j++) {
						if(activeTweens[i].deleteValue(prop[j])) {
							break;
						}
					}
				}
			}
		}
	}
}
