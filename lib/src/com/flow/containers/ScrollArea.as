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
	
	import com.flow.containers.layout.LayoutBase;
	import com.flow.containers.layout.VBoxLayout;
	import com.flow.motion.Tween;
	import com.flow.motion.easing.Quadratic;
	import com.flow.utils.MultiChangeWatcher;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.binding.utils.ChangeWatcher;

	public class ScrollArea extends Container {
		
		private var _scrollX:Number = 0;
		private var _scrollY:Number = 0;
		private var _selectedIndex:Number = 0;
		public var scrollSpeed:Number = 0.5;
		private var firstValidation:Boolean = true;
		private var sizeWatcher:MultiChangeWatcher;
		
		public function ScrollArea() {
			super();
		}
		
		public function get scrollX():Number {
			return _scrollX;
		}
		public function set scrollX(value:Number):void {
			if(value != _scrollX) {
				_scrollX = value;
				invalidate();
			}
		}
		
		public function get scrollY():Number {
			return _scrollY;
		}
		public function set scrollY(value:Number):void {
			if(value != _scrollY) {
				_scrollY = value;
				invalidate();
			}
		}
		
		[Bindable]
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			if(value != _selectedIndex) {
				_selectedIndex = value;
				invalidateProperties();
			}
		}
		
		[Bindable(event="itemCountChanged")]
		public function get itemCount():int {
			return numChildren;
		}
		
		override public function validateProperties():void {
			super.validateProperties();
			if(firstValidation) {
				firstValidation = false;
				scrollTo(selectedIndex, 0);	
			} else {
				scrollTo(selectedIndex, scrollSpeed);
			}
		} 
		
		override public function set measuredHeight(value:Number):void {
			if(measuredHeight != value) {
				super.measuredHeight = value;
				scrollTo(_selectedIndex, 0);
			}
		}
		
		override public function validateChildren():void {
			super.validateChildren();
			dispatchEvent(new Event("itemCountChanged"));
		}
		
		public function scrollTo(index:int, speed:Number, tweenParams:Object = null):Tween {
			validateLayout();
			_selectedIndex = index;
			if(numChildren > _selectedIndex) {
				if(sizeWatcher) {
					sizeWatcher.unwatch();
				}
				var content:DisplayObject = getChildAt(selectedIndex);
				sizeWatcher = new MultiChangeWatcher(content, ["width", "height"], updateSize);
				return new Tween(this, speed, {height:content.height, width:content.width, scrollY:content.y}, tweenParams ? tweenParams : {ease:Quadratic.easeInOut});
			}
			return null;
		}
		
		private function updateSize():void {
			var content:DisplayObject = getChildAt(selectedIndex);
			width = content.width;
			height = content.height;
		}
		
		override protected function applyMask(width:Number, height:Number):void {
			var inset:int = 0;
			if(_stroke) {
				inset = Math.ceil(_stroke.thickness/2);
			}
			if(snapToPixels) {
				scrollRect = new Rectangle(Math.round(_scrollX), Math.round(_scrollY), Math.round(width+inset), Math.round(height+inset));
			} else {
				scrollRect = new Rectangle(_scrollX, _scrollY, width+inset, height+inset);
			}
		}
	}
}