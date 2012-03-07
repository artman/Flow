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

package com.flow.components {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Dispatched when the checkbox is toggled. 
	 */	
	[Event(name="change", type="flash.events.Event")]
	
	/**
	 * A checkbox that can be selected. 
	 */	
	public class Checkbox extends Button {
		
		private var _selected:Boolean = false;
		private var _checker:Component;
		private var hitSprite:Sprite;
		
		/**
		 * Constructor 
		 */		
		public function Checkbox() {
			super();
			hitSprite = new Sprite();
			hitArea = hitSprite;
			hitSprite.visible = false;
			addEventListener(MouseEvent.CLICK, click);
			textFormat = "checkbox";
		}
		
		/**
		 * A label skin part to display the label-property of the Checkbox.
		 */	
		[SkinPart(required="false")]
		override public function set labelDisplay(value:Label):void {
			super.labelDisplay = value
		}
		
		/**
		 * The checker skin part. The checker's active-property is bound to the CheckBox selected-property. 
		 */		
		[SkinPart(required="true")]
		public function set checker(value:Component):void {
			_checker = value;
			_checker.active = _selected;
			//BindingUtils.bindProperty(_checker, "active", this, "selected", false, true);
		}
		public function get checker():Component {
			return _checker;
		}
		
		private function click(e:MouseEvent):void {
			selected = !_selected;
		}
		
		/**
		 * Whether the checkbox is selected or not. 
		 */		
		[Bindable]
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(value:Boolean):void {
			_selected = value;
			if(_checker) {
				_checker.active = _selected;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/** @private */
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
			hitSprite.graphics.clear();
			hitSprite.graphics.beginFill(0);
			hitSprite.graphics.drawRect(0, 0, width, height);
			hitSprite.graphics.endFill();
		}
		
		/** @private */
		override public function validateChildren():void {
			super.validateChildren();
			rawAddChild(hitSprite);
		}
	}
}