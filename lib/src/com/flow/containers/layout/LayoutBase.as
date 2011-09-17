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
	import com.flow.containers.Container;
	
	import flash.display.DisplayObject;
	
	/**
	 * The base class for all layout classes. Layout classes are responsible for laying out the children of a Container. All containers
	 * have a layout class associated. If none is defined, the AbsoluteLayout is used.
	 * 
	 * You can easily create a new layout to support any kind of layout mechanism (e.g. tile lists, 3D carousels, etc).
	 */	
	public class LayoutBase {
		
		public function LayoutBase() {}
		protected var _target:Container;
	
		protected var _paddingLeft:Number = 0;
		protected var _paddingRight:Number = 0;
		protected var _paddingBottom:Number = 0;
		protected var _paddingTop:Number = 0;
		
		/**
		 * If any changes to the properties of your layout instance require a new layout pass, call the invalidate method and a re-layout
		 * of the container associated with the layout will be issued.
		 */		 
		public function invalidate():void {
			if(_target) {
				_target.invalidateLayout();
			}
		}
		
		/** @private */
		public function assignToComponent(target:Container):void {
			this._target = target;
			invalidate();
		}
		
		/** @private */
		public function resignFromComponent(target:Container):void {
			this._target = null;
		}
		
		/**
		 * Called whenever the parent's children have changed. You might need to override this method to implement functionality whenever
		 * the associated containers children change. For example some layout might implement a custom z-sorting of children and would require
		 * to re-sort the display list whenever it changes. 
		 */		
		public function childrenChanged():void {
			// Override
		}
		
		/** @private */
		final public function layout(w:Number, h:Number):void {
			if(_target) {
				layoutChildren(_paddingLeft, _paddingTop, w-_paddingLeft - _paddingRight, h-_paddingTop-_paddingBottom);
			}
		}
		
		/**
		 * This method is called whenever the container's children need to be layed out (e.g. the container dimensions changed). Override this
		 * method in sub-classes to implement the actualy layout functionality. After this event has been processed, all children should have
		 * contain correct positions (and dimensions).
		 * @param The X offset to start layout at.
		 * @param The Y offset to start layout at.
		 * @param The width of the area to lay out all children.
		 * @param The height of the are to lay out all children.
		 */		
		public function layoutChildren(offsetX:Number, offsetY:Number, w:Number, h:Number):void {
			// Override
		}
		
		/**
		 * Padding to be added to all sides when children are layed out.
		 */		
		public function get padding():Number {
			if(_paddingTop == _paddingBottom && _paddingBottom == _paddingLeft && _paddingLeft == _paddingRight) {
				return _paddingTop
			}
			return 0;
		}
		public function set padding(value:Number):void {
			paddingTop = paddingBottom = paddingLeft = paddingRight = value;
		}
		
		/**
		 * Vertical padding to be used when laying out children.
		 */		
		public function get verticalPadding():Number {
			if(_paddingTop == _paddingBottom) {
				return _paddingTop
			}
			return 0;
		}
		public function set verticalPadding(value:Number):void {
			paddingTop = paddingBottom = value;
		}
		
		/**
		 * Horizontal padding to be used when laying out children.
		 */		
		public function get horizontalPadding():Number {
			if(_paddingLeft == _paddingRight) {
				return _paddingLeft;
			}
			return 0;
		}
		public function set horizontalPadding(value:Number):void {
			paddingLeft = paddingRight = value;
		}
		
		/**
		 * Padding used at the top side of the container.
		 */		
		public function get paddingTop():Number {
			return _paddingTop;
		}
		public function set paddingTop(value:Number):void {
			if(value != _paddingTop) {
				_paddingTop = value;
				invalidate();
			}
		}
		
		/**
		 * Padding to be used at the right side of the container. 
		 */		
		public function get paddingRight():Number {
			return _paddingRight;
		}
		public function set paddingRight(value:Number):void {
			if(value != _paddingRight) {
				_paddingRight = value;
				invalidate();
			}
		}
		
		/**
		 * Padding to use at the bottom of the container.
		 */		
		public function get paddingBottom():Number {
			return _paddingBottom;
		}
		public function set paddingBottom(value:Number):void {
			if(value != _paddingBottom) {
				_paddingBottom = value;
				invalidate();
			}
		}
		
		/**
		 * Padding to use on the left side of the container.
		 */		
		public function get paddingLeft():Number {
			return _paddingLeft;
		}
		public function set paddingLeft(value:Number):void {
			if(value != _paddingLeft) {
				_paddingLeft = value;
				invalidate();
			}
		}
		
		/** @private */
		final public function measure():void {
			if(_target) {
				measureChildren();
				_target.measuredWidth += _paddingLeft + _paddingRight;
				_target.measuredHeight += _paddingTop + _paddingBottom;
			}
		}
		
		/**
		 * Called, whenever the component to which the layout is assigned to needs to evaluate it's size. The layout is required
		 * to calculate the size required to fit all of it's children. The measured width and height need to be assigned to the containers
		 * measuredWidth and measuredHeight property (through _target.measuredHeight and _target.measuredWidth).
		 */		
		public function measureChildren():void {
			// Override
		}
		
		/**
		 * A helper function to get the width of a child. Children might be Flow Components or Flash DisplayObjects and their width is
		 * computed differently. 
		 * @param The child of which width to retreive.
		 * @return The width of the child.
		 */
		protected function getWidth(displayObject:DisplayObject):int {
			if(displayObject is Component) {
				return (displayObject as Component).absoluteWidth;
			}
			return displayObject.width;
		}
		
		/**
		 * A helper function to get the height of a child. Children might be Flow Components or Flash DisplayObjects and their height is
		 * computed differently. 
		 * @param The child of which height to retreive.
		 * @return The height of the child.
		 */		
		protected function getHeight(displayObject:DisplayObject):int {
			if(displayObject is Component) {
				return (displayObject as Component).absoluteHeight;
			}
			return displayObject.height;
		}
	}
}