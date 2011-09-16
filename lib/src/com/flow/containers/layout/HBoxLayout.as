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
	
	public class HBoxLayout extends AbsoluteLayout {
		
		private var _spacing:int = 5;
		private var _verticalAlign:String = "middle";
		private var _horizontalAlign:String = "left";
		private var _zSort:String = "normal";
		private var _inverted:Boolean = false;
		
		public function HBoxLayout() {
		}

		public function get spacing():int {
			return _spacing;
		}
		public function set spacing(value:int):void {
			if(value != _spacing) {
				_spacing = value;
				invalidate();
			}
		}
		
		[Inspectable(enumeration="top,middle,bottom,none", defaultValue="middle")]
		public function get verticalAlign():String {
			return _verticalAlign;
		}
		public function set verticalAlign(value:String):void {
			if(value != _verticalAlign) {
				_verticalAlign = value;
				invalidate();
			}
		}
		
		[Inspectable(enumeration="left,center,right", defaultValue="left")]
		public function get horizontalAlign():String {
			return _horizontalAlign;
		}
		public function set horizontalAlign(value:String):void {
			if(value != _horizontalAlign) {
				_horizontalAlign = value;
				invalidate();
			}
		}
		
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
		
		public function get inverted():Boolean {
			return _inverted;
		}
		public function set inverted(value:Boolean):void {
			if(value != inverted) {
				_inverted = value;
				invalidate();
			}
		}
		
		override public function childrenChanged():void {
			if(_zSort == "inverted") {
				flipChildIndexes();
			}
		}
		
		private function flipChildIndexes():void {
			for(var i:int = 1; i<_target.numChildren; i++) {
				_target.setChildIndex(_target.getChildAt(i), 0);
			}
		}
		
		override public function layoutChildren(offsetX:int, offsetY:int, w:int, h:int):void {
			super.layoutChildren(offsetX, offsetY, w, h);
			var maxW:int = 0;
			if(_horizontalAlign != AlignType.ALIGN_LEFT) {
				for(var i:int = 0; i<_target.numChildren; i++) {
					var displayObject:DisplayObject = _target.getChildAt(i) 
					maxW += Math.round(displayObject.width) + (i==0 ? 0 : spacing);	
				}
			}
			var x:int = _horizontalAlign == AlignType.ALIGN_LEFT ? 0 : _horizontalAlign == AlignType.ALIGN_RIGHT ? w - maxW : Math.round((w - maxW) / 2);
			for(i = 0; i<_target.numChildren; i++) {
				var invert:Boolean = _inverted;
				if(_zSort == "inverted") {
					invert = invert ? false : true;
				}
				if(invert) {
					displayObject = _target.getChildAt(_target.numChildren - i - 1);
				} else {
					displayObject = _target.getChildAt(i);
				}
				displayObject.x = x;
				x += Math.ceil(displayObject.width) + spacing;
		
				if(_verticalAlign == AlignType.ALIGN_TOP) {
					displayObject.y = 0;
				} else if(_verticalAlign == AlignType.ALIGN_MIDDLE) {
					displayObject.y = Math.round((h - displayObject.height) / 2);
				} else if(_verticalAlign == AlignType.ALIGN_BOTTOM) {
					displayObject.y = Math.round(h - displayObject.height);
				}
				displayObject.x += offsetX;
				displayObject.y += offsetY;
			}
		}

		override public function measureChildren():void {
			var maxW:int = 0;
			var maxH:int = 0;
			for(var i:int = 0; i<_target.numChildren; i++) {
				var displayObject:DisplayObject = _target.getChildAt(i) 
				var w:int = displayObject.width;
				var h:int = displayObject.height;
				if(displayObject is Component) {
					if(!(displayObject as Component).hasExplicitWidth) {
						w = (displayObject as Component).sanitizeWidth((displayObject as Component).measuredWidth);
					}
					if(!(displayObject as Component).hasExplicitHeight) {
						h = (displayObject as Component).sanitizeHeight((displayObject as Component).measuredHeight);
					}
				}
				maxW += Math.ceil(w) + spacing;
				maxH = Math.max(maxH, h);
			}
			maxW -= spacing;
			_target.measuredWidth = maxW;
			_target.measuredHeight = maxH;
		}
	}
}