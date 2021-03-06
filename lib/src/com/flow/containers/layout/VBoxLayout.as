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

package com.flow.containers.layout {
	
	import com.flow.components.Component;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * A layout that positions children below each other, from top to bottom, taking into consideration their appropriate height. 
	 */	
	public class VBoxLayout extends AbsoluteLayout {
		
		private var _spacing:Number = 0;
		private var _horizontalAlign:String = "left";
		private var _verticalAlign:String = "top";
		private var _zSort:String = "normal";
		private var _inverted:Boolean = false;
		
		/**
		 * Constructor.
		 */		
		public function VBoxLayout() {
		}
		
		/**
		 * The spacing to apply between each child in pixels.
		 */	
		public function get spacing():Number {
			return _spacing;
		}
		public function set spacing(value:Number):void {
			if(value != _spacing) {
				_spacing = value;
				invalidate();
			}
		}
		
		/**
		 * Defines how children are aligned horizontally. Possible values are left, center, right and none. Of these "none" does not try to change
		 * the horizontal position of each child. Instead, the horizontal position is computed according to the position parameters of each child.
		 * @default AlignType.CENTER
		 */	
		[Inspectable(enumeration="left,center,right,none", defaultValue="center")]
		public function get horizontalAlign():String {
			return _horizontalAlign;
		}
		public function set horizontalAlign(value:String):void {
			if(value != _horizontalAlign) {
				_horizontalAlign = value;
				invalidate();
			}
		}
		
		/**
		 * Defines how children are aligned vertically. Possible values are top, middle, bottom. This only has an effect if the parent container is larger (or smaller)
		 * than the combined height of it's children. 
		 * @default AlignType.TOP
		 */	
		[Inspectable(enumeration="top,middle,bottom", defaultValue="top")]
		public function get verticalAlign():String {
			return _verticalAlign;
		}
		public function set verticalAlign(value:String):void {
			if(value != _verticalAlign) {
				_verticalAlign = value;
				invalidate();
			}
		}
		
		/**
		 * Whether the draw-order of all children should be "inverted" or "normal" (default). 
		 */
		[Inspectable(enumeration="normal,inverted", defaultValue="normal")]
		public function get zSort():String {
			return _zSort;
		}
		public function set zSort(value:String):void {
			if(value != _zSort) {
				_zSort = value;
				if(_target) {
					flipChildIndexes();
				}
				invalidate();
			}
		}
		
		/**
		 * Whether the children should be drawn in an inverted order or not. Leaving this at false will draw items from top to bottom,
		 * applying true will make the draw from bottom to top. 
		 */	
		public function get inverted():Boolean {
			return _inverted;
		}
		public function set inverted(value:Boolean):void {
			if(value != inverted) {
				_inverted = value;
				invalidate();
			}
		}
		
		/** @private */ 
		override public function childrenChanged():void {
			if(_zSort == "inverted") {
				flipChildIndexes();
			}
		}
		
		private function flipChildIndexes():void {
			var container:DisplayObjectContainer = _target.childContainer;
			for(var i:int = 1; i<container.numChildren; i++) {
				_target.setChildIndex(container.getChildAt(i), 0);
			}
		}
		
		/** @private */
		override public function layoutChildren(offsetX:Number, offsetY:Number, w:Number, h:Number):void {
			super.layoutChildren(offsetX, offsetY, w, h);
			var container:DisplayObjectContainer = _target.childContainer;
			var maxH:Number = 0;
			if(_verticalAlign != AlignType.ALIGN_TOP) {
				for(var i:int = 0; i<container.numChildren; i++) {
					var displayObject:DisplayObject = container.getChildAt(i) 
					maxH += displayObject.height + (i==0 ? 0 : spacing);	
				}
			}
			
			var y:Number = _verticalAlign == AlignType.ALIGN_TOP ? 0 : _verticalAlign == AlignType.ALIGN_BOTTOM ? h - maxH : (h - maxH) / 2;
		
			for(i = 0; i<container.numChildren; i++) {
				var invert:Boolean = _inverted;
				if(_zSort == "inverted") {
					invert = invert ? false : true;
				}
				if(invert) {
					displayObject = container.getChildAt(container.numChildren - i - 1);
				} else {
					displayObject = container.getChildAt(i);
				}	

				displayObject.y = y;
				y += Math.ceil(displayObject.height) + spacing;
				
				if(_horizontalAlign == AlignType.ALIGN_LEFT) {
					displayObject.x = 0;
				} else if(_horizontalAlign == AlignType.ALIGN_CENTER) {
					displayObject.x = (w - displayObject.width) / 2;
				} else if(_horizontalAlign == AlignType.ALIGN_RIGHT) {
					displayObject.x = w - displayObject.width;
				}
				displayObject.x += offsetX;
				displayObject.y += offsetY;
			}
		}
		
		/** @private */
		override public function measureChildren():void {
			var container:DisplayObjectContainer = _target.childContainer;
			var maxW:Number = 0;
			var maxH:Number = 0;
			for(var i:int = 0; i<container.numChildren; i++) {
				var displayObject:DisplayObject = container.getChildAt(i) 
				var w:Number = displayObject.width;
				var h:Number = displayObject.height;
				if(displayObject is Component) {
					if(!(displayObject as Component).hasExplicitWidth) {
						w = (displayObject as Component).sanitizeWidth((displayObject as Component).measuredWidth);
					}
					if(!(displayObject as Component).hasExplicitHeight) {
						h = (displayObject as Component).sanitizeHeight((displayObject as Component).measuredHeight);
					}
				}
				maxW = Math.max(maxW, w);
				maxH += h + spacing;
			}
			maxH -= spacing;
			_target.measuredWidth = maxW;
			_target.measuredHeight = maxH;
		}
	}
}