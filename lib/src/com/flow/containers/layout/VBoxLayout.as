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
	
	public class VBoxLayout extends AbsoluteLayout {
		
		public function VBoxLayout() {
		}
		
		private var _spacing:int = 0;
		private var _horizontalAlign:String = "center";
		private var _verticalAlign:String = "top";
		private var _zSort:String = "normal";
		private var _inverted:Boolean = false;
		
		public function get spacing():int {
			return _spacing;
		}
		public function set spacing(value:int):void {
			if(value != _spacing) {
				_spacing = value;
				invalidate();
			}
		}
		
		[Inspectable(enumeration="left,center,right", defaultValue="center")]
		public function get horizontalAlign():String {
			return _horizontalAlign;
		}
		public function set horizontalAlign(value:String):void {
			if(value != _horizontalAlign) {
				_horizontalAlign = value;
				invalidate();
			}
		}
		
		[Inspectable(enumeration="top,middle,bottom", defaultValue="top")]
		public function get verticalAlign():String {
			return _verticalAlign;
		}
		public function set veritcalAlign(value:String):void {
			if(value != _verticalAlign) {
				_verticalAlign = value;
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
			var maxH:int = 0;
			if(_verticalAlign != AlignType.ALIGN_TOP) {
				for(var i:int = 0; i<_target.numChildren; i++) {
					var displayObject:DisplayObject = _target.getChildAt(i) 
					maxH += Math.round(displayObject.height) + (i==0 ? 0 : spacing);	
				}
			}
			
			var y:int = _verticalAlign == AlignType.ALIGN_TOP ? 0 : _verticalAlign == AlignType.ALIGN_BOTTOM ? h - maxH : Math.round((h - maxH) / 2);
		
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

				displayObject.y = y;
				y += Math.ceil(displayObject.height) + spacing;
				
				if(_horizontalAlign == AlignType.ALIGN_LEFT) {
					displayObject.x = 0;
				} else if(_horizontalAlign == AlignType.ALIGN_CENTER) {
					displayObject.x = Math.round((w - displayObject.width) / 2);
				} else if(_horizontalAlign == AlignType.ALIGN_RIGHT) {
					displayObject.x = Math.round(w - displayObject.width);
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
				maxW = Math.max(maxW, w);
				maxH += h + spacing;
			}
			maxH -= spacing;
			_target.measuredWidth = maxW;
			_target.measuredHeight = maxH;
		}
	}
}