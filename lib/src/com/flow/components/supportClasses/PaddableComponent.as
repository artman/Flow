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

package com.flow.components.supportClasses {
	import com.flow.components.Component;
	
	/**
	 * A paddable component complements a Component with a number of properties that let the user define paddings for the contents of
	 * the component. Any fills or strokes are painted at the components original width and height, so setting padding won't affect them.
	 */	
	public class PaddableComponent extends Component {
		
		/** @private */  
		protected var _paddingTop:Number = 0;
		/** @private */
		protected var _paddingRight:Number = 0;
		/** @private */
		protected var _paddingLeft:Number = 0;
		/** @private */
		protected var _paddingBottom:Number = 0;
		
		/**
		 * Constructor. 
		 */		
		public function PaddableComponent() {
			super();
		}
		
		/**
		 * The padding for all sides of the components content. 
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
		 * The vertical padding of the components content.
		 */		
		public function get verticalPadding():Number {
			if(_paddingTop == _paddingBottom) {
				return _paddingTop;
			}
			return 0;
		}
		public function set verticalPadding(value:Number):void {
			paddingTop = paddingBottom = value;
		}
		
		/**
		 * The horizontal padding of the components content. 
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
		 * The top padding of the components content. 
		 */		
		public function get paddingTop():Number {
			return _paddingTop;
		}
		public function set paddingTop(value:Number):void {
			if(value != _paddingTop) {
				_paddingTop = value;
				invalidateLayout();
			}
		}
		
		/**
		 * The right-side padding of the components content. 
		 */		
		public function get paddingRight():Number {
			return _paddingRight;
		}
		public function set paddingRight(value:Number):void {
			if(value != _paddingRight) {
				_paddingRight = value;
				invalidateLayout();
			}
		}
		
		/**
		 * The bottom padding of the components content. 
		 */		
		public function get paddingBottom():Number {
			return _paddingBottom;
		}
		public function set paddingBottom(value:Number):void {
			if(value != _paddingBottom) {
				_paddingBottom = value;
				invalidateLayout();
			}
		}
		
		/**
		 * The left-side padding of the components content. 
		 */		
		public function get paddingLeft():Number {
			return _paddingLeft;
		}
		public function set paddingLeft(value:Number):void {
			if(value != _paddingLeft) {
				_paddingLeft = value;
				invalidateLayout();
			}
		}
		
		/** @private */		
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
			width -= (_paddingLeft + _paddingRight);
			if(width < 0) {
				width = 0;
			}
			height -= (_paddingTop + _paddingBottom);
			if(height < 0) {
				height = 0;
			}
			drawWithPadding(_paddingLeft, _paddingTop, width, height);
		}
		
		/**
		 * Override this method to draw when extending the PaddableComponent instead of overrideing the draw-method. This method
		 * is called whenever the components dimensions have changed and the component needs to validate itself. 
		 * @param The x offset at which to begin drawing.
		 * @param The y offset at which to begin drawing.
		 * @param The width to draw.
		 * @param The height to draw.
		 */		
		protected function drawWithPadding(offsetX:Number, offsetY:Number, width:Number, height:Number):void {
			// Override
		}
		
		/** @private */		
		override final public function measure():void {
			measureWithPadding( _paddingLeft + _paddingRight, _paddingTop + _paddingBottom);
		}
		
		/**
		 * Override this method to measure the dimensions of the component when extending the PaddableComponent instead of overriding
		 * the measure-method.
		 * 
		 * This method is called whenever the component needs to be measured. Sub-classes should implement this to ensure
		 * that the component can be used without explicitly setting it's width and height.
		 * 
		 * Implementations should measure the minimum width and height that the component requires to fully draw itself
		 * (e.g. depending on the text in a Label). The method does not return anything. Instead, for a full implementation,
		 * set the measuredWidth and measuredHeight properties of the component according to your measurement results. 
		 * @param The total horizontal padding to add to the measurement result.
		 * @param The total vertical padding to add to the measurement result.
		 * 
		 */		
		protected function measureWithPadding(horizontal:Number, vertical:Number):void {
			
		}
	}
}