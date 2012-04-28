/**
 * Copyright (c) 2012 Tuomas Artman, http://artman.fi
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
	 * A layout that positions children next to each other, from left to right, taking into consideration their appropriate width. 
	 */	
	public class TileLayout extends AbsoluteLayout {
		
		private var _spacing:Number = 0;
		private var _horizontalSpacing:Number = 0;
		private var _verticalSpacing:Number = 0;
		private var _verticalAlign:String = "middle";
		private var _horizontalAlign:String = "left";
		private var _zSort:String = "normal";
		private var _inverted:Boolean = false;
		
		/**
		 * Constructor.
		 */		
		public function TileLayout() {
			super();
		}
		
		/**
		 * The spacing to apply between each child in pixels. Setting this property will apply it to both the horizontalSpacing and
		 * verticalSpacing properties.
		 */		
		public function get spacing():Number {
			if(_horizontalSpacing == _verticalSpacing) {
				return _horizontalSpacing;
			}
			return 0;
		}
		public function set spacing(value:Number):void {
			_horizontalSpacing = _verticalSpacing = value;
		}
		
		/**
		 * The horizontal spacing to apply between each child in pixels.
		 */		
		public function get horizontalSpacing():Number {
			return _horizontalSpacing;
		}
		public function set horizontalSpacing(value:Number):void {
			if(_horizontalSpacing != value) {
				_horizontalSpacing = value;
				invalidate();
			}
		}
		
		/**
		 * The vertical spacing to apply between each child in pixels.
		 */		
		public function get verticalSpacing():Number {
			return _verticalSpacing;
		}
		public function set verticalSpacing(value:Number):void {
			if(_verticalSpacing != value) {
				_verticalSpacing = value;
				invalidate();
			}
		}
		
		/**
		 * Defines how children within a row are aligned vertically. Possible values are top, middle, bottom and none. Of these "none" does not try to change
		 * the vertical position of each child. Instead, the vertical position is computed according to the position parameters of each child.
		 * @default AlignType.MIDDLE
		 * @see com.flow.containers.layout.AlignType
		 */		
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
		
		/**
		 * How to align rows of children horizontaly within their parent container.
		 * @default AlignType.LEFT
		 * @see com.flow.containers.layout.AlignType
		 */		
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
		 * Whether the children should be drawn in an inverted order or not. Leaving this at false will draw items from left to right,
		 * applying true will make the draw from right to left. 
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
		
		/** @private */ 
		private function flipChildIndexes():void {
			var container:DisplayObjectContainer = _target.childContainer;
			for(var i:int = 1; i<container.numChildren; i++) {
				_target.childContainer.setChildIndex(container.getChildAt(i), 0);
			}
		}
		
		/** @private */
		override public function layoutChildren(offsetX:Number, offsetY:Number, w:Number, h:Number):void {
			super.layoutChildren(offsetX, offsetY, w, h);
			var container:DisplayObjectContainer = _target.childContainer;

			var rows:Array = getRowItemCount(w);
			
			var rowYOffset:Number = 0;
			var childIndex:int = 0;
			
			for(var row:int = 0; row < rows.length; row++) {
				var maxW:int = 0;
				var maxH:int = 0;
				var childCount:int = rows[row];

				for(var i:int = childIndex; i<childIndex + childCount; i++) {
					var displayObject:DisplayObject = container.getChildAt(i) 
					maxW += displayObject.width + (i==0 ? 0 : spacing);	
					maxH = Math.max(displayObject.height);
				}
				
				var x:int = _horizontalAlign == AlignType.ALIGN_LEFT ? 0 : _horizontalAlign == AlignType.ALIGN_RIGHT ? w - maxW : (w - maxW) / 2;
				for(i = childIndex; i<childIndex + childCount; i++) {
					var invert:Boolean = _inverted;
					if(_zSort == "inverted") {
						invert = invert ? false : true;
					}
					if(invert) {
						displayObject = container.getChildAt(container.numChildren - i - 1);
					} else {
						displayObject = container.getChildAt(i);
					}
					displayObject.x = x;
					x += Math.ceil(displayObject.width) + spacing;
					
					if(_verticalAlign == AlignType.ALIGN_TOP) {
						displayObject.y = 0;
					} else if(_verticalAlign == AlignType.ALIGN_MIDDLE) {
						displayObject.y = (maxH - displayObject.height) / 2;
					} else if(_verticalAlign == AlignType.ALIGN_BOTTOM) {
						displayObject.y = maxH - displayObject.height;
					}
					displayObject.x += offsetX;
					displayObject.y += offsetY + rowYOffset;
				}
				rowYOffset += maxH + _verticalSpacing;
				childIndex += rows[row];
			}
		}
		
		private function getRowItemCount(width:Number):Array {
			var rows:Array = [];
			var remainingW:Number = width;
			var cnt:int = 0;
			var container:DisplayObjectContainer = _target.childContainer;
			for(var i:int = 0; i<container.numChildren; i++) {
				var displayObject:DisplayObject = container.getChildAt(i) 
				remainingW -= displayObject.width + (i==0 ? 0 : spacing);	
				cnt++;
				if(remainingW <= 0) {
					if(cnt > 1) {
						cnt--;
						i--;
					}
					rows.push(cnt);
					remainingW = width;
					cnt = 0;
				} else if(i == container.numChildren-1) {
					rows.push(cnt);
				}
			}
			return rows;
		}
	
		
		/** @private */
		override public function measureChildren():void {
			var rows:Array = getRowItemCount(_target.hasExplicitWidth ? _target.width : Number.MAX_VALUE);
			var container:DisplayObjectContainer = _target.childContainer;
			
			trace("Rows " + rows);
			
			var totalW:Number = 0;
			var totalH:Number = 0;
		
			var rowYOffset:Number = 0;
			var childIndex:int = 0;
			
			for(var row:int = 0; row < rows.length; row++) {
				var maxW:int = 0;
				var maxH:int = 0;
				var childCount:int = rows[row];
				
				for(var i:int = childIndex; i<childIndex + childCount; i++) {
					var displayObject:DisplayObject = container.getChildAt(i) 
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
					maxW += Math.ceil(w) + (i==0 ? 0 : _horizontalSpacing);	
					maxH = Math.max(maxH, Math.ceil(h));
				}
				
				totalW = Math.max(totalW, maxW);
				totalH += maxH + (row == 0 ? 0 : _verticalSpacing);
				childIndex += rows[row];
			}
			
			trace("Measure " + totalW + " " + totalH);
			
			_target.measuredWidth = totalW;
			_target.measuredHeight = totalH;
		}
	}
}