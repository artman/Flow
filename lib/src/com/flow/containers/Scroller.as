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
	
	import com.flow.components.HScrollBar;
	import com.flow.components.VScrollBar;
	import com.flow.containers.layout.LayoutBase;
	import com.flow.containers.layout.VBoxLayout;
	import com.flow.motion.Tween;
	import com.flow.motion.easing.Quadratic;
	import com.flow.utils.MultiChangeWatcher;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.binding.utils.ChangeWatcher;
	
	public class Scroller extends Container {
		
		private var _scrollX:Number = 0;
		private var _scrollY:Number = 0;
		private var hScrollBar:HScrollBar;
		private var vScrollBar:VScrollBar;
		
		public function Scroller() {
			super();
			childContainer = new Sprite();
			hScrollBar = new HScrollBar();
			vScrollBar = new VScrollBar();
			rawAddChild(childContainer);
			rawAddChild(hScrollBar);
			rawAddChild(vScrollBar);
			vScrollBar.addEventListener(Event.CHANGE, checkScroll);
			hScrollBar.addEventListener(Event.CHANGE, checkScroll);
		}
		
		protected function checkScroll(event:Event = null):void {
			if(measuredWidth > contentWidth) {
				scrollX = (measuredWidth - contentWidth) * hScrollBar.value;
				hScrollBar.thumbSizePercentage = contentWidth / measuredWidth;
			} else {
				scrollX = 0;
				hScrollBar.value = 0;
			}
			if(measuredHeight > contentHeight) {
				scrollY = (measuredHeight - contentHeight) * vScrollBar.value;
				vScrollBar.thumbSizePercentage = contentHeight / measuredHeight;
			} else {
				scrollY = 0;
				vScrollBar.value = 0;
			}
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
		
		override public function validateProperties():void {
			super.validateProperties();
		}
		
		override public function invalidateLayout(fromChild:Boolean=false):void {
			super.invalidateLayout(fromChild);
			manager.invalidateComponent(this);
			invalidated = true;
		}
		
		override public function validateLayout(e:Event=null):void {
			super.validateLayout(e);
			vScrollBar.validateNow();
			hScrollBar.validateNow();
			
			hScrollBar.visible = measuredWidth > width;
			vScrollBar.visible = measuredHeight > height;
			
			hScrollBar.visible = measuredWidth > contentWidth;
			vScrollBar.visible = measuredHeight > contentHeight;

			hScrollBar.y = height - hScrollBar.height;
			hScrollBar.width = contentWidth;
			
			vScrollBar.x = width - vScrollBar.width;
			vScrollBar.height = contentHeight;
			checkScroll();
		}
		
		public function get contentWidth():Number {
			return width - (vScrollBar.visible ? vScrollBar.width : 0);
		}
		
		public function get contentHeight():Number {
			return height - (hScrollBar.visible ? hScrollBar.height : 0);
		}
		
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
		}
		
		override protected function applyMask(width:Number, height:Number):void {
			var inset:int = 0;
			if(_stroke) {
				inset = Math.ceil(_stroke.thickness/2);
			}
			childContainer.x = childContainer.y = inset;
			childContainer.scrollRect = new Rectangle(_scrollX, _scrollY, contentWidth-inset, contentHeight-inset);
		}
	}
}