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
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * A simple label that can be clicked 
	 */	
	public class LabelButton extends Label {
		
		private var _underline:Boolean = false;
		private var hitSprite:Sprite;
		
		/** Constructor */
		public function LabelButton() {
			super();
			interactive = true;
			hitSprite = new Sprite();
			addChild(hitSprite);
			hitArea = hitSprite;
			hitSprite.visible = false;
		}
		
		/**
		 * Sets the text of the LabelButton. This is the same as setting the text-property.  
		 */		
		public function get label():String {
			return _text;
		}
		public function set label(value:String):void {
			super.text = value;
		}
		
		/**
		 * Set whether the text should be underlined. 
		 */		
		public function get underline():Boolean {
			return _underline;
		}
		public function set underline(value:Boolean):void {
			if(value != _underline) {
				_underline = value;
				invalidateProperties();
			}
		}
		
		/** @inheritDoc */
		override public function set disabled(value:Boolean):void {
			super.disabled = value;
			if(value) {
				addEventListener(MouseEvent.CLICK, disableClick, false, 1000);
				useHandCursor = false;
			} else {
				removeEventListener(MouseEvent.CLICK, disableClick);
				useHandCursor = true;
			}
		}
		
		/** @private */
		override protected function decorateTextFormat(textFormat:TextFormat):void {
			super.decorateTextFormat(textFormat);
			if(_underline) {
				textFormat.underline = true;
			}
		}

		private function disableClick(e:MouseEvent):void {
			e.stopImmediatePropagation();
		}
		
		/** @private */
		override public function draw(width:Number, height:Number):void {
			super.draw(width, height);
			hitSprite.graphics.clear();
			hitSprite.graphics.beginFill(0);
			hitSprite.graphics.drawRect(0, 0, width, height);
			hitSprite.graphics.endFill();
		}
	}
}