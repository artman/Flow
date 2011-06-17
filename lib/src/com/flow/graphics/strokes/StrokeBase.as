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

package com.flow.graphics.strokes {
	
	import com.flow.events.InvalidationEvent;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.events.EventDispatcher;
	
	/**
	 * The base class for all strokes that can be used to draw borders around components. This class should not
	 * be used directly. Instead, use one of it's subclasses.
	 */	
	[Event(name="invalidate", type="com.flow.events.InvalidationEvent")]
	public class StrokeBase extends EventDispatcher implements IStroke {
		
		/** @private */
		protected var _thickness:Number = 1;
		/** @private */
		protected var _caps:String = CapsStyle.ROUND;
		/** @private */
		protected var _joints:String = JointStyle.ROUND;
		/** @private */
		protected var _miterLimit:Number = 3;
		/** @private */
		protected var _pixelHinting:Boolean = true;
		
		/**
		 * Constructor. 
		 */		
		public function StrokeBase() {
		}
		
		/**
		 * The caps style of the stroke (default round).
		 */		
		[Inspectable(enumeration="none,round,square", defaultValue="round")]
		public function get caps():String {
			return _caps;
		}
		public function set caps(value:String):void {
			if(value != _caps) {
				_caps = value;
				invalidate();
			}
		}
		
		/**
		 * The joints style of the stroke (default round).
		 */		
		[Inspectable(enumeration="bevel,miter,round", defaultValue="round")]
		public function get joints():String {
			return _joints;
		}
		public function set joints(value:String):void {
			if(value != _joints) {
				_joints = value;
				invalidate();
			}
		}
		
		/**
		 * The meter limit of the stroke (default 3).
		 */		
		public function get miterLimit():Number {
			return _miterLimit;
		}
		public function set miterLimit(value:Number):void {
			if(value != _miterLimit) {
				_miterLimit = value;
				invalidate();
			}
		}
		
		/**
		 * The thickness of the stroke (default 1).
		 */		
		[Animateable]
		public function get thickness():Number {
			return _thickness;
		}
		public function set thickness(value:Number):void {
			if(value != _thickness) {
				_thickness = value;
				invalidate();
			}
		}
		
		/**
		 * Whether to draw the stroke with pixel hinting (default true). 
		 */		
		public function get pixelHinting():Boolean {
			return _pixelHinting;
		}
		public function set pixelHinting(value:Boolean):void {
			if(value != _pixelHinting) {
				_pixelHinting = value;
				invalidate();
			}
		}
		
		/**
		 * Subclasses override this method to set the lineStyle on the give graphics context. 
		 * @param graphics
		 * @param width
		 * @param height
		 * 
		 */		
		public function beginDraw(graphics:Graphics, width:int, height:int):void  {
			// Override
		}
		
		/**
		 * Subclasses call invalidate whenever properties, that affect the visual representation of the stroke change.
		 * This will force a re-render of the component to which the stroke is assigned to.
		 */		
		public function invalidate():void {
			dispatchEvent(new InvalidationEvent(InvalidationEvent.INVALIDATE));
		}
	}
}