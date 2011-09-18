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
		
	/**
	 * A container that can be used to scroll through it's children. Changing the selectedIndex property will have the ScrollArea smoothly
	 * scroll it's content to show the component at the selected index. In addition to scrolling, the ScrollArea will also change it's size to
	 * accomodate the component at the selected index.
	 */	
	public class ScrollArea extends Container {
		
		private var _scrollX:Number = 0;
		private var _scrollY:Number = 0;
		private var _selectedIndex:Number = 0;
		
		/**
		 * The speed to use when scrolling to a new item. 
		 */		
		public var scrollSpeed:Number = 0.5;
		private var firstValidation:Boolean = true;
		private var sizeWatcher:MultiChangeWatcher;
		
		/**
		 * Constructor.
		 */		
		public function ScrollArea() {
			super();
		}
		
		/** @private */
		override protected function getDefaultLayout():LayoutBase {
			var ret:VBoxLayout = new VBoxLayout();
			ret.horizontalAlign = "center";
			return ret;
		}
		
		/**
		 * The number of pixels scrolled horizontally. Normaly you wouldn't set this property directly, but would set the selectedIndex
		 * property to have the ScrollArea show a specific child.
		 */		
		public function get scrollX():Number {
			return _scrollX;
		}
		public function set scrollX(value:Number):void {
			if(value != _scrollX) {
				_scrollX = value;
				invalidate();
			}
		}
		
		/**
		 * The number of pixels scrolled vertically. Normaly you wouldn't set this property directly, but would set the selectedIndex
		 * property to have the ScrollArea show a specific child.
		 */		
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
		/**
		 * The childs index to show. Setting this property will make the ScrollArea pan to that child and smoothly adjust it's size
		 * to accomodate the child.
		 */		
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			if(value != _selectedIndex && value != -1) {
				_selectedIndex = value;
				invalidateProperties();
			}
		}
		
		/** @private */  
		[Bindable(event="itemCountChanged")]
		public function get itemCount():int {
			return numChildren;
		}
		
		/** @private */
		override public function validateProperties():void {
			super.validateProperties();
			if(firstValidation) {
				firstValidation = false;
				scrollTo(selectedIndex, 0);	
			} else {
				scrollTo(selectedIndex, scrollSpeed);
			}
		} 
		
		/** @private */
		override public function set measuredHeight(value:Number):void {
			if(measuredHeight != value) {
				super.measuredHeight = value;
				scrollTo(_selectedIndex, 0);
			}
		}
		
		/** @private */
		override public function validateChildren():void {
			super.validateChildren();
			dispatchEvent(new Event("itemCountChanged"));
		}
		
		/**
		 * Instead of seting the selectedIndex-property you can call the scrollTo method. This is usefull if you want to scroll
		 * to an item with a custom speed or tween parameters. 
		 * @param The child index to scroll to.
		 * @param The speed of the pan in seconds.
		 * @param Any tween paramters to be assigned to the Tween.
		 * @return The Tween instance responsible for the pan and size change. 
		 */		
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
		
		/** @private */
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