
package com.flow.components {
	
	import com.flow.components.supportClasses.SkinnableComponent;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.binding.utils.BindingUtils;
	import mx.states.State;
	
	[SkinState("up")]
	[SkinState("disabled")]
	[Event(name="change", type="flash.events.Event")]
	/**
	 * A horizontal scrollbar component with a track, thumb and optional arrows buttons.
	 */	
	public class HScrollBar extends SkinnableComponent {
		
		private var _decreaseButton:Button;
		private var _increaseButton:Button;
		private var _thumb:Button;
		private var _track:DisplayObject;
		private var _value:Number = 0;
		/** @private */
		protected var direction:String = "horizontal";
		private var _minimum:Number = 0;
		private var _maximum:Number = 1;
		private var _thumbSizePercentage:Number = 0;
		private var originalThumbSize:Point;
		private var scrollDirection:int;
		private var scrollTimer:Timer;
		private var downPercentage:Point;
		
		/** @private */
		public function HScrollBar() {
			super();
			states = [
				new State("up"),
				new State("disabled")
			];
		}
		
		/**
		 * A skin part representing the thumb of the scrollbar. 
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
				originalThumbSize = new Point(_thumb.width, _thumb.height);
				_thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumbDown);
			}
		}
		
		[SkinPart(required="false")]
		/**
		 * A optional skin part representing the left arrow of the scrollbar.  
		 */		
		public function get decreaseButton():Button {
			return _decreaseButton;
		}
		public function set decreaseButton(value:Button):void {
			if(value != _decreaseButton) {
				if(_decreaseButton) {
					_decreaseButton.removeEventListener(MouseEvent.MOUSE_DOWN, decreaseDown);
				}
				_decreaseButton = value;
				_decreaseButton.addEventListener(MouseEvent.MOUSE_DOWN, decreaseDown);
			}
		}
		
		[SkinPart(required="false")]
		/**
		 * A optional skin part representing the right arrow of the scrollbar. 
		 */		
		public function get increaseButton():Button {
			return _increaseButton;
		}
		public function set increaseButton(value:Button):void {
			if(value != _increaseButton) {
				if(_increaseButton) {
					_increaseButton.removeEventListener(MouseEvent.MOUSE_DOWN, increaseDown);
				}
				_increaseButton = value;
				_increaseButton.addEventListener(MouseEvent.MOUSE_DOWN, increaseDown);
			}
		}
		
		[SkinPart(required="true")]
		/**
		 * A required skin part representing the track of the scrollbar. The thumb will move within the rect of this track.
		 */		
		public function get track():DisplayObject {
			return _track;
		}
		public function set track(value:DisplayObject):void {
			_track = value;
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
			removeEventListener(Event.ENTER_FRAME, thumbMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, thumbUp);
		}
		
		/** @private */
		protected function decreaseDown(e:MouseEvent):void {
			startScrolling(-1);
		}
		
		/** @private */
		protected function increaseDown(e:MouseEvent):void {
			startScrolling(1);
		}
		
		/** @private */
		protected function startScrolling(direction:int):void {
			scrollDirection = direction;
			stage.addEventListener(MouseEvent.MOUSE_UP, stopScrolling);
			scrollTimer = new Timer(500);
			scrollTimer.addEventListener(TimerEvent.TIMER, scrollTick);
			scrollTimer.start();
			scrollTick();
		}
		
		/** @private */
		protected function scrollTick(event:TimerEvent = null):void {
			if(scrollTimer.currentCount == 1) {
				scrollTimer.delay = 30
			}
			if(scrollDirection == -1 && decreaseButton.currentState != "down") {
				return;
			}
			if(scrollDirection == 1 && increaseButton.currentState != "down") {
				return;
			}
			if(thumbSizePercentage) {
				var areaSize:Number = size / thumbSizePercentage;
				var scrollPercentage:Number = 20 / areaSize;
			} else {
				scrollPercentage = 0.01;
			}
			value += (maximum - minimum) * scrollDirection * scrollPercentage;
		}
		
		private function stopScrolling(e:MouseEvent):void {
			scrollTimer.stop();
			scrollTimer = null;
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrolling);
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
		 * The minimum value of this scrollbar. 
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
		 * The maximum value of the scrollbar. 
		 */		
		public function get maximum():Number {
			return _maximum;
		}
		public function set maximum(value:Number):void {
			_maximum = value;
			minimum = Math.min(_minimum, _maximum);
			this.value = Math.min(_value, _minimum);
		}
		
		[Bindable]
		/**
		 * The size of the thumb in percent of the track size. 
		 */		
		public function get thumbSizePercentage():Number {
			return _thumbSizePercentage;
		}
		public function set thumbSizePercentage(value:Number):void {
			_thumbSizePercentage = Math.max(0, Math.min(1, value));
			invalidateProperties();
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
				_thumb.width = thumbSizePercentage ? _track.width * thumbSizePercentage : originalThumbSize.x;
				_thumb.x = _track.x + (_track.width - _thumb.width) * percentage;
			} else {
				_thumb.height = thumbSizePercentage ? _track.height * thumbSizePercentage : originalThumbSize.y;
				_thumb.y = _track.y + (_track.height - _thumb.height) * percentage;
			}
		}
	}
}