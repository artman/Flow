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
	
	import com.flow.components.supportClasses.SkinnableComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.states.State;
	
	[SkinState("up")]
	[SkinState("down")]
	[SkinState("disabled")]
	
	/**
	 * Dispatched when the value of the scollbar changes. 
	 */
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * A horizontal slider component with a track and thumb with optional value label
	 */	
	public class HSlider extends SkinnableComponent {
		
	
		private var _thumb:Button;
		private var _track:DisplayObject;
		private var _value:Number = 0;
		/** @private */
		protected var direction:String = "horizontal";
		private var _minimum:Number = 0;
		private var _maximum:Number = 1;
		private var _thumbSizePercentage:Number = 0;
		private var scrollDirection:int;
		private var downPercentage:Point;
		
		/** @private */
		public function HSlider() {
			super();
			states = [
				new State("up"),
				new State("down"),
				new State("disabled")
			];
		}
		
		/**
		 * A skin part representing the thumb of the slider. 
		 */		
		[SkinPart(required="true")]
		public function get thumb():Button {
			return _thumb;
		}
		public function set thumb(value:Button):void {
			if(value != _thumb) {
				if(_thumb) {
					_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
				}
				_thumb = value;
				_thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
			}
		}
		
		[SkinPart(required="true")]
		/**
		 * A required skin part representing the track of the slider. The thumb will move within the rect of this track.
		 */		
		public function get track():DisplayObject {
			return _track;
		}
		public function set track(value:DisplayObject):void {
			if(value != _track) {
				if(_track) {
					_track.removeEventListener(MouseEvent.MOUSE_DOWN, trackClicked);
				}
				_track = value;
				_track.addEventListener(MouseEvent.MOUSE_DOWN, trackClicked);
			}
		}
		
		protected function trackClicked(e:MouseEvent):void {
			var percent:Number = direction == "horizontal" ? track.mouseX / track.width : track.mouseY / track.height;
			percent = Math.min(Math.max(0, percent), 1);
			value = minimum  + percent * (maximum - minimum);
		}
		
		[Bindable]		
		/**
		 * The value of the scrollbar. 
		 */		
		public function get value():Number {
			return _value;
		} 
		public function set value(val:Number):void {
			_value = Math.min(_maximum, Math.max(_minimum, val));
			invalidate();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/** @inheritDoc */		
		override public function set disabled(value:Boolean):void {
			super.disabled = value;
			if(value) {
				addEventListener(MouseEvent.CLICK, disableClick, false, 1000);
				useHandCursor = false;
			} else {
				removeEventListener(MouseEvent.CLICK, disableClick);
				useHandCursor = true;
			}
		}
		
		private function disableClick(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		
		/** @private */
		protected function thumbDown(e:MouseEvent):void {
			currentState = "down";
			downPercentage = new Point(thumb.mouseX / thumb.width, thumb.mouseY / thumb.height);
			addEventListener(Event.ENTER_FRAME, thumbMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, thumbUp);
		}
		
		/** @private */
		protected function thumbMove(event:Event):void {
			if(direction == "horizontal") {
				var percentage:Number =  (mouseX - downPercentage.x * thumb.width - _track.x) / (_track.width - _thumb.width);
			} else {
				percentage =  (mouseY - downPercentage.y * thumb.height - _track.y) / (_track.height - _thumb.height);
			}
			value = _minimum + Math.max(0, Math.min(1, percentage)) * (_maximum - _minimum);
		}
		
		/** @private */
		protected function thumbUp(event:MouseEvent):void {
			currentState = "up";
			removeEventListener(Event.ENTER_FRAME, thumbMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, thumbUp);
		}
		
		/** @private */
		public function get size():Number {
			if(direction == "horizontal") {
				return width;
			}
			return height;
		}
		
		
		[Bindable]
		/**
		 * The minimum value of the slider. 
		 */		
		public function get minimum():Number {
			return _minimum;
		}
		public function set minimum(value:Number):void {
			_minimum = value;
			maximum = Math.max(_minimum, _maximum);
			this.value = Math.max(_value, _minimum);
		}
		
		[Bindable]
		/**
		 * The maximum value of the slider. 
		 */		
		public function get maximum():Number {
			return _maximum;
		}
		public function set maximum(value:Number):void {
			_maximum = value;
			minimum = Math.min(_minimum, _maximum);
			this.value = Math.min(_value, _minimum);
		}
				
		/** @private */ 
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
			if(_minimum == _maximum) {
				var percentage:Number = 0
			} else {
				percentage = (_value - _minimum) / (_maximum - _minimum);
			}
			if(direction == "horizontal") {
				_thumb.x = _track.x + (_track.width - _thumb.width) * percentage;
			} else {
				_thumb.y = _track.y + (_track.height - _thumb.height) * percentage;
			}
		}
	}
}