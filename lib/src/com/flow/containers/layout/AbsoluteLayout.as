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
	
	import avmplus.getQualifiedClassName;
	
	import com.flow.components.Component;
	import com.flow.components.measuring.MeasureUnit;
	import com.flow.components.measuring.MeasureUnits;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.net.getClassByAlias;
	import flash.utils.getDefinitionByName;
	
	/**
	 * A basic layout method where each child's location and dimensions are computed independently. Children may use
	 * percentages for position and dimensions and are layed out according to any constraints (top, right, etc...).
	 */	
	public class AbsoluteLayout extends LayoutBase {
		
		/**
		 * Constructor 
		 */		
		public function AbsoluteLayout() {
		}
		
		/* @private */
		override public function layoutChildren(offsetX:Number, offsetY:Number, w:Number, h:Number):void {
			var container:DisplayObjectContainer = _target.childContainer;
			
			for(var i:int = 0; i<_target.childContainer.numChildren; i++) {
				
				if(container.getChildAt(i) is Component) {
					var group:Component = container.getChildAt(i) as Component;
					var m:MeasureUnits = group.measureUnits;
					
					if(m.left.isNull || m.right.isNull) {
						if(!m.w.isNull) {
							group.absoluteWidth = parseDimension(w, m.w);
						}
						if(m.horizontalCenter.isNull) {
							if(!m.right.isNull) {
								group.x = w - group.width - parseDimension(w, m.right);
							} else if(!m.left.isNull) {
								group.x = parseDimension(w, m.left);
							}
						} else {
							group.x = w/2 - group.width/2 + parseDimension(w, m.horizontalCenter);
						}
					} else {
						group.absoluteWidth = w - parseDimension(w, m.left) - parseDimension(w, m.right);
						group.x = parseDimension(w, m.left);
					}
					
					if(m.top.isNull || m.bottom.isNull) {
						if(!m.h.isNull) {
							group.absoluteHeight = parseDimension(h, m.h);
						}
						if(m.verticalCenter.isNull) {
							if(!m.bottom.isNull) {
								group.y = h - group.height - parseDimension(h, m.bottom);
							} else if(!m.top.isNull) {
								group.y = parseDimension(h, m.top);
							}
						} else {
							group.y = h/2 - group.height/2 + parseDimension(h, m.verticalCenter);
						}
					} else {
						group.absoluteHeight = h - parseDimension(h, m.top) - parseDimension(h, m.bottom);
						group.y = parseDimension(h, m.top);
					}
					
					group.x += offsetX;
					group.y += offsetY;
				}
			}	
		}
		
		private function parseDimension(total:Number, m:MeasureUnit):Number {
			if(m.isNull) {
				return 0;
			}
			if(!m.isPercentage) {
				return m.value;
			}
			return total * m.value / 100.00;
		}
		
		override public function measureChildren():void {
			var container:DisplayObjectContainer = _target.childContainer;
			var maxW:Number = 0;
			var maxH:Number = 0;
			
			for(var i:int = 0; i<container.numChildren; i++) {
				var child:DisplayObject = container.getChildAt(i);
				w = child.x + child.width;
				h = child.y + child.height;
				if(child is Component) {			
					var comp:Component = child as Component;
					var m:MeasureUnits = comp.measureUnits;
					
					var w:Number = comp.width;
					var h:Number = comp.height;
					
					if(!comp.hasExplicitWidth) {
						w = comp.sanitizeWidth(comp.measuredWidth);
					}
					if(!comp.hasExplicitHeight) {
						h = comp.sanitizeHeight(comp.measuredHeight);
					}
		
					if(m.left.isNull && m.right.isNull) {
						w += comp.x;
					} else {
						w += m.left.value;
					}
					if(!m.right.isNull) {
						w += m.bottom.value;
					}
					
					if(m.top.isNull && m.bottom.isNull) {
						h += comp.y;
					} else {
						h += m.top.value;
					}
					if(!m.bottom.isNull) {
						h += m.bottom.value;
					}
					
				}
				maxW = Math.max(maxW, w);
				maxH = Math.max(maxH, h);
			}
			
			_target.measuredWidth = maxW;
			_target.measuredHeight = maxH;
		}
	}
}